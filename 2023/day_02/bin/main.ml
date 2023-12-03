let puzzle_infile = "data/input.dat"
let red_cubes = 12
let green_cubes = 13
let blue_cubes = 14

(* PART 1 *)

let arr_to_rgb arr =
    (arr.(0), arr.(1), arr.(2))

(* [(count, order), ..] -> (r,g,b) *)
let sort_unordered_rgb unordered_rgb =
    match unordered_rgb with
    | [(c1,o1)] -> (arr_to_rgb (Array.init 3 ((fun i -> if o1 = i then c1 else 0))))
    | [(c1,o1); (c2, o2)] -> (arr_to_rgb (Array.init 3 ((fun i -> if o1 = i then c1 else if o2 = i then c2 else 0))))
    | [(c1,o1); (c2, o2); (c3, o3)] -> (arr_to_rgb (Array.init 3 ((fun i -> if o1 = i then c1 else if o2 = i then c2 else if o3 = i then c3 else 0))))
    | _ -> (0,0,0)

let rbg_order color =
    match color with
    | "red" -> 0
    | "green" -> 1
    | "blue" -> 2
    | _ -> -1

let entry_to_count_color entry =
    match (String.split_on_char ' ' (String.trim entry)) with
    | [count; color] -> (int_of_string count, rbg_order color)
    | _ -> (0,0)

let record_to_rgb record =
    sort_unordered_rgb (List.map entry_to_count_color (String.split_on_char ',' record))

let check_valid (rlim,glim,blim) record =
    let (rs,gs,bs) = record_to_rgb record in
    ((rs <= rlim) && (gs <= glim) && (bs <= blim))

let is_possible records bag =
    let record_list = String.split_on_char ';' records in
    List.for_all (fun b -> b = true) (List.map (check_valid bag) record_list)

let get_id head =
    match (String.split_on_char ' ' head) with
    | [_; id] -> int_of_string id
    | _ -> 0

let id_or_zero line bag =
    match (String.split_on_char ':' line) with
    | [head; records] -> if (is_possible records bag) then get_id head else 0
    | _ -> 0

let rec sum_ids ic total =
    try
        let line = input_line ic in
        sum_ids ic (total + (id_or_zero line (red_cubes, green_cubes, blue_cubes)))
    with _ ->
        close_in_noerr ic;
        total

let () =
    let ic = open_in puzzle_infile in
    try
        (* Part 1 *)
        let id_sum = sum_ids ic 0 in
        print_endline (string_of_int id_sum)
    with e ->
        close_in_noerr ic;
        raise e

(* PART 2 *)

let get_red rgb =
    match rgb with
    | (r,_,_) -> r

let get_green rgb =
    match rgb with
    | (_,g,_) -> g

let get_blue rgb =
    match rgb with
    | (_,_,b) -> b

let max_rgb records =
    let record_list = String.split_on_char ';' records in
    let rgb_list = List.map record_to_rgb record_list in
    let reds = (List.map get_red rgb_list) in
    let greens = (List.map get_green rgb_list) in
    let blues = (List.map get_blue rgb_list) in
    ((List.fold_left max 0 reds), (List.fold_left max 0 greens), (List.fold_left max 0 blues))

let min_required line =
    match (String.split_on_char ':' line) with
    | [_; records] -> max_rgb records
    | _ -> (0,0,0)

let power_of_min_required line =
    let (rmin, bmin, gmin) = min_required line in
    (rmin * bmin * gmin)

let rec sum_powers ic total =
    try
        let line = input_line ic in
        sum_powers ic (total + (power_of_min_required line))
    with _ ->
        close_in_noerr ic;
        total

let () =

    let ic = open_in puzzle_infile in
    try
        let power_sum = sum_powers ic 0 in
        print_endline (string_of_int power_sum)
    with e ->
        close_in_noerr ic;
        raise e
