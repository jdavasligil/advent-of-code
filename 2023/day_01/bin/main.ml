(* https://adventofcode.com/2023/day/1 *)
exception NoDigit of string

let file = "data/input.dat"

let is_digit c =
    match c with
    '0' .. '9' -> true
    | _ -> false;;

let rec first_digit s idx len =
    if idx < len then
        if is_digit (String.get s idx) then
            Some (Char.code (String.get s idx) - (Char.code '0'))
        else 
            first_digit s (idx + 1) len
    else
        None

let rec last_digit s idx =
    if idx >= 0 then
        if is_digit (String.get s idx) then
            Some (Char.code (String.get s idx) - (Char.code '0'))
        else 
            last_digit s (idx - 1)
    else
        None

let two_digit s = 
    let first = match (first_digit s 0 (String.length s)) with
    | Some x -> x
    | None -> raise (NoDigit "First digit not found!") in

    let last = match (last_digit s (String.length s - 1)) with
    | Some x -> x
    | None -> raise (NoDigit "Last digit not found!") in

    (first * 10) + last

let rec sum_digits ic total =
    try
        let line = input_line ic in
        try
            sum_digits ic (total + two_digit line)
        with e ->
            close_in_noerr ic;
            raise e
    with _ ->
        close_in_noerr ic;
        total

let () =
    let ic = open_in file in
    try
        let total = sum_digits ic 0 in
        print_endline(string_of_int total)
    with e ->
        close_in_noerr ic;
        raise e
