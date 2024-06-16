open Hft.Graph
open Hft.Market

let () =
  Random.self_init ();
  let market = { price = 100.; volatility = 0.1; drift = -0.1; dt = 0.1 } in
  plot_market market 1000
