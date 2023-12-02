(* https://adventofcode.com/2023/day/1 *)

let file = "data/calibration.dat"
let is_digit c = match c with '0' .. '9' -> true | _ -> false
let two_digit s = s

let () =
  let ic = open_in file in
  try
    let line = input_line ic in
    print_endline line;
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
