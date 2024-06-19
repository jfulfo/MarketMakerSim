(***
  MARKET SIMULATOR
  - we need to come up with an extensible way to simulate "the market"
  - it may be sufficient to encode just brownian motion with some
    sinusoidal cycles and a trend line
  - we could also go further but doing that with orders, but then
    we need a way to manage orders -- not obvious
  - we could also ignore models and use "brokers" that have certain
    moods and behaviors and have them make orders based on that
  - with the brokers we don't actually have to find out a way to
    model the market, we just have to model people are make a
    good order book
    ***)

type market_type =
  { price : float
  ; volatility : float
  ; drift : float
  ; dt : float
  }

(* We also need a way to store the history of the market *)
type market_history = market_type list

let geometric_brownian m =
  let dW = (Random.float 1.0 -. 0.5) *. 4.0 in
  { m with
    price = m.price +. (m.drift *. m.dt) +. (m.volatility *. m.price *. sqrt m.dt *. dW)
  }
;;

let rec geometric_brownian_markets markets =
  match markets with
  | [] -> []
  | m :: ms -> geometric_brownian m :: geometric_brownian_markets ms
;;

let market_prices markets = List.map (fun m -> m.price) markets

let rec simulate_history history market time_steps =
  match time_steps with
  | 0 -> history
  | n -> simulate_history (market :: history) (geometric_brownian market) (n - 1)
;;

(* This would be easy in a class, but for now let's avoid OOP *)
let simulate_history_with_market market time_steps = simulate_history [] market time_steps

let pp_market fmt m =
  Format.fprintf
    fmt
    "Price: %f, Volatility: %f, Drift: %f, dt: %f"
    m.price
    m.volatility
    m.drift
    m.dt
;;

let pp_market_history fmt ms =
  Format.fprintf fmt "[@[%a@]]" (Format.pp_print_list pp_market) ms
;;
