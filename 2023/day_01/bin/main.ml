(* https://adventofcode.com/2023/day/1 *)
exception NoDigit of string

let file = "data/input.dat"

let is_digit c =
    match c with
    '0' .. '9' -> true
    | _ -> false;;

let is_digit_prefix pre =
    match pre with
    | "o" -> true
    | "t" -> true
    | "f" -> true
    | "s" -> true
    | "e" -> true
    | "n" -> true
    | _ -> false

let next_prefix pre =
    match pre with
    | "on" -> "one"
    | "tw" -> "two"
    | "th" -> "thr"
    | "thr" -> "thre"
    | "thre" -> "three"
    | "fo" -> "fou"
    | "fou" -> "four"
    | "fi" -> "fiv"
    | "fiv" -> "five"
    | "si" -> "six"
    | "se" -> "sev"
    | "sev" -> "seve"
    | "seve" -> "seven"
    | "ei" -> "eig"
    | "eig" -> "eigh"
    | "eigh" -> "eight"
    | "ni" -> "nin"
    | "nin" -> "nine"
    | _ -> ""
    
let is_digit_str s = 
    match s with
    | "one" -> true
    | "two" -> true
    | "three" -> true
    | "four" -> true
    | "five" -> true
    | "six" -> true
    | "seven" -> true
    | "eight" -> true
    | "nine" -> true
    | _ -> false

let digit_str_to_int s = 
    match s with
    | "one" -> 1
    | "two" -> 2
    | "three" -> 3
    | "four" -> 4
    | "five" -> 5
    | "six" -> 6
    | "seven" -> 7
    | "eight" -> 8
    | "nine" -> 9
    | _ -> 0

let rec try_digit_from_str s head tail len =

    if tail < len then 

        let substr = String.sub s head (tail - head) in
        let next_substr = String.sub s head (tail + 1 - head) in

        if is_digit_str substr then
            digit_str_to_int substr
        else if (next_prefix substr) = next_substr then
            try_digit_from_str s head (tail + 1) len
        else
            -tail + 1

    else if tail = len then

        let substr = String.sub s head (tail - head) in

        if is_digit_str substr then
            digit_str_to_int substr
        else
            -tail + 1
    else
        -tail + 1

let rec first_digit s idx len =

    if idx < len then
        if is_digit (String.get s idx) then
            Some (Char.code (String.get s idx) - (Char.code '0'))

        else if is_digit_prefix (String.sub s idx 1) then
            let maybe_digit = try_digit_from_str s idx (idx + 2) len in
            if maybe_digit > 0 then
                Some maybe_digit
            else
                first_digit s (-maybe_digit) len

        else 
            first_digit s (idx + 1) len
    else
        None

let rec last_digit s idx len =
    match (first_digit s idx len) with
    | Some x -> x
    | None -> if idx > 0 then last_digit s (idx - 1) len else -1

(*
let rev_str s = String.init (String.length s) ((fun s i -> String.get s (String.length s - i - 1)) s) 
*)

let two_digit s = 
    let first = match (first_digit s 0 (String.length s)) with
    | Some x -> x
    | None -> raise (NoDigit "First digit not found!") in

    let last = last_digit s (String.length s - 1) (String.length s) in

    if (last = -1) then
        raise (NoDigit "Last digit not found!")
    else
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
