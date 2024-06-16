(* We want to either:
   - take in a market type and plot history for n time steps
   - take in a market history and just plot the history *)

open Market
open Graphics

let plot_market_history history =
  open_graph " 800x600";
  set_window_title "Market History";
  let max_price = List.fold_left (fun acc m -> max acc m.price) 0.0 history in
  let scale_x = 800.0 /. float_of_int (List.length history) in
  let scale_y = 600.0 /. max_price in
  moveto 0 (int_of_float (List.hd history).price);
  List.iteri
    (fun i m ->
      let x = int_of_float (float_of_int i *. scale_x) in
      let y = int_of_float (m.price *. scale_y) in
      lineto x y)
    history;
  ignore (read_key ())

(* Suppose we are given a market and time_steps *)
let plot_market market time_steps =
  let history = simulate_history_with_market market time_steps in
  plot_market_history history
