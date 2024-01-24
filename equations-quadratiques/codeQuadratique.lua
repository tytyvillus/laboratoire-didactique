-- All functions are defined locally, and only user-accessible functions are exported at the end.
-- The practices followed are given by [this stackexchange answer](https://tex.stackexchange.com/a/464049).

-- IMPORTANT NOTE: algorithm assumes a, b, c \in \mathbb{Z}
--> generalising the algorithm to non-integer a, b, c will be a bit of work, 
--  because luacas isn't very happy with non-integer coefficients 


---------------------------------------
--------  (EDITABLE) PREAMBLE  --------
---------------------------------------

-- SET GLOBAL SEED 
--> set manually if you want a reproducible sheet:
math.randomseed(os.time()) -- e.g. 2 or os.time()

-- GENERAL PARAMETERS --> modify at will

local function easy_factor(a, x1, x2)
    -- boolean test; decides whether a*x^2 + b*x + c is easy to factorise or not
    -- where x1, x2 are the solutions s.t. a*x^2 + b*x + c = a*(x-x1)*(x-x2)
    -- n.b. a::Int, x1::Float, x2::Float|Nil

    local decision = true -- by default, if x2 is nil, poly is easy to factor

    if x2 ~= nil then

        decision = (x1 % 1 == 0) and (x2 % 1 == 0) and --> check integer solutions
            (   
                (
                    (
                        math.max(math.abs(x1),math.abs(x2)) <= 12
                        or math.min(math.abs(x1),math.abs(x2)) <= 3
                    ) 
                and
                    (math.abs(a) <= 5 or a == 10 or math.abs(a*x1*x2) % 10 == 0)
                )
                or (math.abs(a*x1*x2) <= 144)
            ) 
            --> these choices were made using gut instinct and trial-and-error
            -- feel free to change 

    end

    return decision

end

local whether_from_factored_form = function () 
    -- randomly decides whether choose solutions first (return true)
    -- or generate a, b, c at random (return false)
    if math.random(10) <= 7 --> weightings, feel free to change
        then return true 
        else return false 
    end 
end

local enforce_perfect_square = function ()
    -- randomly chooses to enforce a perfect-square polynomial (return true)
    -- or just leave things alone (return false)
    if math.random(10) == 1 --> weightings, feel free to change
        then return true
        else return false
    end
end



-- HELPER FUNCTIONS --

local function is_one_of (value, table)
    -- checks whether value is one of the elements of table
    for idx, val in ipairs(table) do
        if value == val then return true end
    end
    return false
end

local function map (tbl, f)
    -- applies function to table
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

local function range (n)
    -- generates table from 1 to n
    assert(n % 1 == 0 and n > 0, "argument of range should be a positive integer")
    local list = {}
    for i = 1, n, 1 do
        list[i] = i
    end
    return list
end

local function approx (x, y)
    -- checks approximate equality, within 10^(-6)
    if math.abs(x-y) < 1e-6 then return true else return false end
end



---------------------------------------
----------  MAIN  ALGORITHM  ----------
---------------------------------------

-- ALGORITHM PART 1: POLYNOMIAL GENERATOR -- 

-- warning: have a lot of checks of type a==0

-- Generate quadratic polynomials:
local function generate_polynomial() 
    -- returns {a, b, c, num_sols, x1, x2, rat}

    -- initialise generate_polynomial() outputs, fixes scope:
    local a, b, c, num_sols, x1, x2, delta

    -- decide whether integer solutions or not:
    local rat = whether_from_factored_form()

    if rat == true then -- integer solutions
        local sol_bdy = 12 -- boundary of solution range

        -- generate two solutions:
        x1 = math.random(-sol_bdy, sol_bdy)
        if enforce_perfect_square() then x2 = x1 else -- artificially bump up number of perfect squares
        x2 = math.random(-sol_bdy, sol_bdy) end

        -- also generate leading coefficient:
        a = (-1)^math.random(2) * math.random(10) -- avoid zero
        -- now compute other coefficients:
        b = - a * (x1 + x2)
        c = a * x1 * x2

        -- set number of and order solutions
        if x1 == x2 then num_sols, x2 = 1, nil -- set number of solutions to one and clear x2
        else num_sols = 2 -- set number of solutions to two
            if x1 > x2 then x1, x2 = x2, x1 end -- order solutions correctly
        end
    
    else -- totally random solutions
        a = math.random(-10,10) -- zero (linear equation) allowed (with low probability, cf rat == true)
        b = math.random(-20,20)
        c = math.random(-60,60)

        -- Compute solutions:
        if a == 0 then-- if linear then either
            if b == 0 then -- no x-dependence
                if c == 0 then num_sols, x1, x2 = math.huge, nil, nil -- "0 = 0"
                    --> might have to hardcode this special case later
                    --> essentially, here reserve num_sols = math.huge for S = \R
                else num_sols, x1, x2 = 0, nil, nil end -- "0 = 1"
            else -- or linear
                num_sols, x1, x2 = 1, -c / b, nil -- (and delta = nil)
        end
        else delta = b^2 - 4*a*c -- elseif quadratic
            -- if quadratic, do the three cases
            if delta == 0 then -- one solution with multiplicity two
                num_sols = 1
                x1 = - b / (2*a)
                x2 = nil
            elseif delta < 0 then -- no solutions
                num_sols = 0
                x1 = nil
                x2 = nil
            elseif delta > 0 then -- two separate solutions
                num_sols = 2
                x1 = (- b - math.sqrt(delta)) / (2*a)
                x2 = (- b + math.sqrt(delta)) / (2*a)
            else assert(false,"You broke the law of excluded middle, wtf dude.")
            end
        end
    end

    return {a, b, c, num_sols, x1, x2, rat}
end




-- ALGORITHM PART 2: OPTIMAL METHOD DETECTOR --

local function pick_method(a, b, c, num_sols, x1, x2, rat)
    -- a, b, c are the polynomial coefficients (number type)
    -- num_sols is the number of solutions (number type, values in {0, 1, 2})
    -- x1, x2 are the solutions of the equation a x^2 + b x + c = 0 (number type)
    -- rat is a flag for which version of the generation algorithm was used (boolean type)

    --assert(num_sols == math.huge or (num_sols >= 0 and num_sols <= 2), -- remove if works
    assert( is_one_of(num_sols, {0, 1, 2, math.huge}), 
        "Woah, something went wrong -- I didn't receive a sensible number of solutions.")

    local method = "" -- initialise string containing the answer method

    -- run through different preset methods when problem has solution:
    if num_sols == math.huge then method = [[par évidence]] --> S = \R case

    elseif num_sols ~= 0 then
        if a==0 then method = [[équation de premier degré, à résoudre algébriquement]]
        elseif b==0 then method = [[par réarrangement \(\left(\text{attention à }\pm\sqrt{\square}\right)\)]]
        elseif c==0 then method = [[par mise en évidence de \(ax\)]]
        elseif -- (rat == true) or -- "rat==true" commented out because should already be covered by easy_factor
            easy_factor(a, x1, x2) -- test whether easily factorised by hand
            then 
                if num_sols == 1 then method = [[par identité remarquable (carré parfait)]] -- (x \pm x1)^2 = 0
                    else method = [[par factorisation du trinôme]]
                end -- then, if a =/= 1, remind of necessity of bringing $a$ out the front
                if a ~= 1 then method = [[diviser par \(a\), puis ]]..method end
        else method = [[avec la formule de Viète]]
        end

    -- give instead methods when problem has no solution:
    else method = [[sans solutions]] -- initalise as no solutions, just in case
        if a==0 and b==0 and c~=0 then method = [[évidemment]]
        elseif b==0 then method = [[somme de positifs ne fait jamais zéro]]
        else method = [[formule de Viète / en calculant le discriminant \((\Delta)\)]]
        end 
    end

    return method
end


---------------------------------------
----------- PREPARE OUTPUTS -----------
---------------------------------------

-- PRINT LUALATEX-FORMATTED EQUATION --

local function cas_equation (a, b, c) 
    -- prints equation using luacas

    local tex_string = "" -- initialise

    -- randomly choose form, then create with luacas:
    if math.random(10) > 2 then --> normal in 8/10 cases
        -- f(x) = a*x^2 + b*x + c
        tex_string = string.format(
            [[
                \begin{CAS}
                    vars('x')
                    f = %d * x^2 + %d * x + %d
                    f = topoly(f)
                \end{CAS}
                \print{f} = 0
            ]], -- work out in luacas, then print
            a, b, c
        ) 
    elseif b ~= 0 and math.random(3) == 1 then
        -- x = - c/b - a/b x^2
        tex_string = string.format(
            [[
                \begin{CAS}
                    vars('x')
                    a = %d
                    b = %d
                    c = %d
                    f = topoly(- c / b - a / b * x^2)
                \end{CAS}
                x = \print{f}
            ]],
            a, b, c
        ) 
    elseif a*b ~= 0 and math.random(2) == 1 then
        -- c/a = -x(x + b/a)
            --> n.b. b must be zero otherwise get c/a = -x(x)
        tex_string = string.format(
            [[
                \begin{CAS}
                    vars('x')
                    a = %d
                    b = %d
                    c = %d
                    f = c/a
                    g = topoly(-x(x + b/a))
                \end{CAS}
                \print{f} = \print{g}
            ]],
            a, b, c
        )  
    else -- a x^2 = -b x - c
        tex_string = string.format(
            [[
                \begin{CAS}
                    vars('x')
                    a = %d
                    b = %d
                    c = %d
                    f = topoly(a*x^2)
                    g = topoly(-b*x-c)
                \end{CAS}
                \print{f} = \print{g}
            ]],
            a, b, c
        ) 
    end

    return tex_string
end

-- PRINT LUALATEX-FORMATTED ANSWER --

local function cas_sol_set (a, b, c, num_sols, x1, x2, rat)
    -- gets luacas to calculate and simplify solutions 
    -- outputs string to tex.print in math environment

    local S -- initialise output string

    -- cases:

    if num_sols == math.huge then S = [[\mathbb{R}]] -- "0 = 0"
    
    elseif num_sols == 0 then S = [[\emptyset]] -- no sols

    elseif num_sols == 1 then 
        if a == 0 then S = string.format( -- one sol to linear eqn
            [[
            \begin{CAS}
            x1 = - %d / %d         
            \end{CAS}
            \left\{ \print*{x1} \right\}
            ]],
            c, b
        ) --> x = - c / b
        else S = string.format( -- one sol to quadratic eqn
            [[        
            \begin{CAS}
            x1 = - %d / (2*%d)         
            \end{CAS}
            \left\{ \print*{x1} \right\}
            ]],
            b, a 
        ) --> x1 = b / (2*a)
        end

    elseif num_sols == 2 then S = string.format( -- two sols
        [[        
        \begin{CAS}
        vars('x')
        f = %d*x^2 + %d*x + %d
        S = roots(f)
        \end{CAS}
        \left\{ \print*{S[1]}; \print*{S[2]} \right\}
        ]],
        a, b, c
    ) --> roots of a*x^2 + b*x + c

    else assert(false,"There is a deep error -- number of solutions not being tracked correctly.")
    end -- debugging

    return S
end

local function num_sol_set (a, b, c, num_sols, x1, x2, rat)
    -- create numerical solution set as string
    -- CURRENTLY UNDER DEBUGGING

    local sol_set_list = {} -- initialise solution set
    local S = "" -- initialise output string

    -- since appending nil to an empty table does nothing, append both solutions
    table.insert(sol_set_list, x1) -- first small
    table.insert(sol_set_list, x2) -- then big

    -- preprocess formatting: turn entries into strings with \num
    for idx, val in ipairs(sol_set_list) do --> cycle through elements
        sol_set_list[idx] = string.format([[\num{%s}]], val)
    end

    -- preprocess formatting: combine into output string with set notation
    --> if empty, replaces with empty set symbol; else just fills braces
    if next(sol_set_list) == nil --> check table empty
        then S = [[\emptyset]] 
        else S = string.format([[\left\{%s\right\}]], table.concat(sol_set_list, "; "))
    end 

    return S
end

local function answer_line (a, b, c, num_sols, x1, x2, rat)
    -- print the answer in the form "par factorisation, $S = \{1; 2\}$" :

    local output_string = string.format(
        [[{%s}, \(S = %s\)]],
        pick_method(a, b, c, num_sols, x1, x2, rat),
        cas_sol_set(a, b, c, num_sols, x1, x2, rat)
    )
    
    -- if solutions aren't integers, then also give numerical values
    if is_one_of(num_sols, {1, 2})
    and ( (x1 % 1 ~= 0) or (x2 ~= nil and x2 % 1 ~= 0) ) --> if there are non-integer solutions
        then 
            output_string = output_string..string.format(
                [[\( \approx %s \)]],
                num_sol_set(a, b, c, num_sols, x1, x2, rat) -- nb: fn only actually uses x1, x2
            ) 
        --> formats and appends numerical solutions x1, x2 to output string
    end

    return output_string
end



-- FULL ROUTINE 

local function print_questions_and_answers()
    -- compute some coefficients
    local polynomial_coeffs = generate_polynomial()

    -- print the equation
    tex.print(
        [[\begin{equation}]]..
        cas_equation(table.unpack(polynomial_coeffs,1,3)) --> cas provides equation
        ..[[\end{equation}]] --> then, enclose in $$.$$
    ) --> write to tex

    -- print the solution
    tex.print(
        answer_line(table.unpack(polynomial_coeffs)) --> = "avec [méthode], S = {x1;x2}"
    )

end

local function full_routine(n)
    -- takes an integer and outputs question + answer text numbered with that integer

    -- compute some coefficients
    local polynomial_coeffs = generate_polynomial()

    -- create equation string
    local eqn_string = [[\(]]..
        cas_equation(table.unpack(polynomial_coeffs,1,3)) --> cas provides equation
        ..[[\)]] --> then, enclose in \(...\)

    -- create answer string
    local ans_string = answer_line(table.unpack(polynomial_coeffs)) --> = "avec [méthode], S = {x1;x2}"

    -- produce output tex with properly formatted answer key
    local output_string = string.format([[
        \begin{customquestion} %02d.~~\ %s \end{customquestion}
		\begin{customanswer}   %02d.~~  \ %s \end{customanswer}
        ]], n, eqn_string, n, ans_string)

    tex.print(output_string)
end


-- INTERFACE WITH LUALATEX ENGINE --

-- Export user-accessible functions (renamed using syntax `new = old`):
return { 
    polynomial = generate_polynomial, -- returns {a, b, c, num_sols, x1, x2, rat}
    methodString = pick_method, -- provides recommended method
    printEquation = cas_equation, -- question preprinted for LaTeX
    answer = answer_line, -- answer preprinted for LaTeX
    fullRoutine = full_routine, -- whole shebang
    printQnA = print_questions_and_answers, -- alternative, single-equation formatting style
}