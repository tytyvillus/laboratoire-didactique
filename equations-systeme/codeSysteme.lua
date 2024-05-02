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

-- Set probability to generate singular matrices (number between 0 and 1)
probability_singular = 0.2 -- here 20% of the generated singular equations systems will be kept (the real proportion is way less, since the probability of generating a singular matrix fully at random approaches 0)

local function whether_singular () 
    -- randomly decides whether choose top have a unique solution first (return true)
    -- or generate a singular system (return false)
    if math.random(10)/10 <= probability_singular --> weightings, feel free to change
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

function flatten(v)
    local res = {}
    local function flatten(v)
        if type(v) ~= "table" then
            table.insert(res, v)
            return
        end
        for _, v in ipairs(v) do
            flatten(v)
        end
    end
    flatten(v)
    return res
end


---------------------------------------
----------  MAIN  ALGORITHM  ----------
---------------------------------------

-- ALOGRITHM PART 0: EQUATION SOLVER --

-- Function to solve a system of linear equations by linear combination (Cramer's rule)
-- If the system is of the form a1x + b1y = c1 , a2x + b2y = c2

function solveLinearEquations(system)
    local a1, b1, c1 = system[1], system[2], system[3]
    local a2, b2, c2 = system[4], system[5], system[6]
    -- Calculate determinant
    local determinant = a1 * b2 - b1 * a2
    
    -- Check if the determinant is zero
    if determinant == 0 then
        print("The lines are either overlapping or parallel.")
        return nil
    else    
        -- Calculate x and y using Cramer's rule
        local x = (b2 * c1 - b1 * c2) / determinant
        local y = (a1 * c2 - a2 * c1) / determinant

        -- local x_num, x_den = decimalToFraction(x)
        -- local y_num, y_den = decimalToFraction(y)
        return x, y
    end
end


-- ALGORITHM PART 1: POLYNOMIAL GENERATOR -- 

-- warning: have a lot of checks of type a==0

-- Generate two factors linear polynomials:
 -- generate 2x2 matrices to have 0, 1 or infinitely many solutions depending on the random number given (if the matrix is singular, then it will be wiped away 80% of the time)
local function generate_system(probability_singular)
    
    local rat = whether_singular()

    if rat == true then -- integer solutions
        if math.random()<= 0.5 then
            local coef_bdy = 12 -- boundary of coefficient range

            -- generate first equation
            local a1 = math.random(-coef_bdy, coef_bdy)
            local b1 = math.random(-coef_bdy, coef_bdy)
            local c1 = math.random(-coef_bdy, coef_bdy)

            -- also generate proportionality coefficient:
            local k = math.random(-7, 7)
            -- now compute other coefficients:
            local a2, b2, c2 = k*a1, k*b1, k*c1
            system = {a1, b1, c1, a2, b2, c2}
            return system
        else
            local coef_bdy = 12 -- boundary of coefficient range

            -- generate first equation
            local a1 = math.random(-coef_bdy, coef_bdy)
            local b1 = math.random(-coef_bdy, coef_bdy)
            local c1 = math.random(-coef_bdy, coef_bdy)

            -- also generate proportionality coefficient:
            local k = math.random(-7, 7)
            -- now compute other coefficients:
            local a2, b2, c2 = k*a1, k*b1, c1

            system = {a1, b1, c1, a2, b2, c2}

            return system
        end

    else -- Generate random values for the matrix
        local a1 = math.random(-10, 10)
        local b1 = math.random(-10, 10)
        local a2 = math.random(-10, 10)
        local b2 = math.random(-10, 10)
        
        -- Choose arbitrary constants for the linear equations
        local c1 = math.random(-15, 15)
        local c2 = math.random(-15, 15)
        local system = {a1, b1, c1, a2, b2, c2}
        -- Check if the determinant is non-zero
        local determinant = a1 * b2 - b1 * a1
        
        if determinant==0 then 
            return generate_system(probability_singular)
        else 
            -- Return the system
            return system
        end
    end
end

    -- Function to generate a system of linear equations using the coefficients the generated matrix
local function generate_linear_system(matrix)
    -- Choose arbitrary constants for the linear equations
    local c1 = math.random(-15, 15)
    local c2 = math.random(-15, 15)

    -- Extract coefficients from the matrix
    local a1, b1, a2, b2 = matrix[1][1], matrix[1][2], matrix[2][1], matrix[2][2]

    -- Generate the system of linear equations
    local system = {a1, b1, c1, a2, b2, c2}
    return system
end

    -- function that determines the number of solutions of the system
  -- function that determines the number of solutions of the system
local function number_solutions_two(eqs)
    -- Coefficients from equations
    local a1, b1, c1 = eqs[1], eqs[2], eqs[3]
    local a2, b2, c2 = eqs[4], eqs[5], eqs[6]
    local det = a1 * b2 - a2 * b1

    if det ~= 0 then
        -- unique solution
        return 1
    else
        -- verifiy if the lines coincide or if they are parallel
        local ratio_a = a1 / a2
        local ratio_b = b1 / b2
        local ratio_c = c1 / c2
        
        if (a1 == 0 and a2 == 0) and (b1 == 0 and b2 == 0) then
            if c1 == c2 then
                return math.huge  -- zero system
            else
                return 0  -- Impossible if c1 != c2
            end
        elseif (a1 == 0 and a2 == 0) or (b1 == 0 and b2 == 0) then
            -- one variable is totally missing
            if ratio_c == (b1 == 0 and b2 == 0 and ratio_a or ratio_b) then
                return math.huge
            else
                return 0
            end
        else
            if ratio_a == ratio_b and ratio_b == ratio_c then
                -- lines coincide
                return math.huge
            else
                -- parallel lines
                return 0
            end
        end
    end
end       

local function generate_exercise(probability_singular)
    local system = generate_system(probability_singular)
    local num_sols = number_solutions_two(system)
    local x, y = solveLinearEquations(system)
    
    return system, num_sols, x, y
end

-- ALGORITHM PART 2: OPTIMAL METHOD DETECTOR --

local function pick_method_case(system, num_sols)
    -- system is the matrix of coefficients of the system
    -- num_sols is the number of solutions (number type, values in {0, 1, math.huge})
    a, b, d, e = system[1], system[2], system[4], system[5]
    assert( is_one_of(num_sols, {0, 1, math.huge}), 
        "Woah, something went wrong -- I didn't receive a sensible number of solutions.")

    local method = "" -- initialise string containing the answer method

    -- run through different preset methods when problem has solution:
    if num_sols == math.huge then method = [[les deux équations sont dépendantes]] --> S = line case, i.e. (a&d==0 and b&e==0 and c&f==0) or (d&a==0 and e&b==0 and f&c==0)

    elseif num_sols == 1 then
        if a==0 or b==1 then method = [[isoler \(y\) dans la 1\textsuperscript{re} équation, substituer ensuite]]
        elseif b==0 or a==1 then method = [[isoler \(x\) dans la 1\textsuperscript{re} équation, substituer ensuite]]
        elseif d==0 or e==1 then method = [[isoler \(y\) dans la 2\textsuperscript{e} équation, substituer ensuite]]
        elseif e==0 or d==1 then method = [[isoler \(x\) dans la 2\textsuperscript{e} équation, substituer ensuite]]
        elseif a==d or b==e then method = [[soustraction directe des deux équations]]
        elseif a==-d or b==-e then method = [[addition directe des deux équations]]
        elseif a%b==0 then method = string.format([[diviser par \(%d\) puis isoler \(y\) dans la 1\textsuperscript{re} équation, substituer ensuite]], b)
        elseif b%a==0 then method = string.format([[diviser par \(%d\) puis isoler \(x\) dans la 1\textsuperscript{re} équation, substituer ensuite]], a)
        elseif d%e==0 then method = string.format([[diviser par \(%d\) puis isoler \(y\) dans la 2\textsuperscript{e} équation, substituer ensuite]], e)
        elseif e%d==0 then method = string.format([[diviser par \(%d\) puis isoler \(x\) dans la 2\textsuperscript{e} équation, substituer ensuite]], d)
        else method = [[par combinaison linéaire]]
        end

    -- give instead methods when problem has no solution:
    else method = [[sans solutions (combinaison linéaire donne $1=0$)]]   
    end
    return method
end

---------------------------------------
----------- PREPARE OUTPUTS -----------
---------------------------------------

-- PRINT LUALATEX-FORMATTED EQUATION --

local function cas_equation (system) 
    -- prints equation using luacas

    tex_string = string.format(
            [[
                \begin{CAS}
                    vars('x', 'y')
                    f = Equation(%d * x + %d * y, %d)
                    g = Equation(%d * x + %d * y, %d)
                \end{CAS}
                \left\{\begin{array}{c} \print*{f} \\ \print*{g}\end{array}\right.
            ]], -- work out in luacas, then print
            table.unpack(system)
        ) 
    return tex_string
end

-- PRINT LUALATEX-FORMATTED ANSWER --

local function cas_sol_set (system, num_sols, x, y)
    -- outputs string to tex.print in math environment

    local S -- initialise output string

    -- cases:

    if num_sols == math.huge then 
        S = string.format(
        [[
            \begin{CAS}
            vars('x', 'y')
            f= Equation(%d * x + %d * y, %d):autosimplify()
            eqx = f:solvefor(y)
            \end{CAS}
            \left\{ 
                \left(x, \print{eqx.rhs}\right) \; \middle| \; x \in \mathbb{R}
            \right\}
        ]], -- droites confondues
        table.unpack(system)
    )
    
    elseif num_sols == 0 then S = [[\emptyset]] -- no sols

    --  A MODIFIER ABSOLUMENT POUR AVOIR LES FRACTIONS EXACTES DES SOLUTIONS
    elseif num_sols == 1 then 
        S = string.format(
        [[
            \begin{CAS}
            determinant = %d * %d - %d * %d
            x = (%d * %d - %d * %d) / determinant
            y = (%d * %d - %d * %d) / determinant
            \end{CAS}
            \left\{\left(\print*{x}, \print*{y} \right)\right\}
        ]], -- droites sécantes
        system[1], system[5], system[4], system[2], system[5], system[3], system[2], system[6], system[1], system[6], system[4], system[3]
    )
    else assert(false,"There is a deep error -- number of solutions not being tracked correctly.")
    end 
    return S
end

local function num_sol_set (system, num_sols, x, y)
    -- create numerical solution set as string
    -- CURRENTLY UNDER DEBUGGING

    local sol_set_list = {} -- initialise solution set
    local S = "" -- initialise output string
    
    -- since appending nil to an empty table does nothing, append both solutions
    table.insert(sol_set_list, x) -- first small
    table.insert(sol_set_list, y) -- then big

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

local function answer_line (system, num_sols, x, y)
    -- print the answer in the correct form:

    local output_string = string.format(
        [[{%s}, \(S = %s\)]],
        pick_method_case(system, num_sols),
        cas_sol_set(system, num_sols, x, y)
    )

    return output_string
end


-- FULL ROUTINE 

local function print_questions_and_answers()
    -- compute some coefficients and the associated equations
    local coeffs, num_sols, x, y = generate_exercise(probability_singular)

    -- print the equation
    tex.print(
        [[\begin{equation}]]..
        cas_equation(coeffs) --> cas provides equation
        ..[[\end{equation}]] --> then, enclose in $$.$$
    ) --> write to tex

    -- print the solution
    tex.print(
        answer_line(coeffs, num_sols, x, y) --> = "avec [méthode], S = ..."
    )

end

local function full_routine(n)
    -- takes an integer and outputs question + answer text numbered with that integer
    -- compute coefficients and the associated equations
    local coeffs, num_sols, x, y = generate_exercise(probability_singular)

    -- create equation string
    local eqn_string = [[\(]]..
        cas_equation(coeffs) --> cas provides equation
        ..[[\)]] --> then, enclose in \(...\)

    -- create answer string
    local ans_string = answer_line(coeffs, num_sols, x, y) --> = "avec [méthode], S = {x1;x2}"

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
    polynomial = generate_exercise, -- returns {coefficients, num_sols, x, y}
    methodString = pick_method, -- provides recommended method
    printEquation = cas_equation, -- question preprinted for LaTeX
    answer = answer_line, -- answer preprinted for LaTeX
    fullRoutine = full_routine, -- whole shebang
    printQnA = print_questions_and_answers, -- alternative, single-equation formatting style
}
