type market =
  { price : float
  ; volatility : float
  ; drift : float
  ; dt : float
  }

val geometric_brownian : market -> market
val geometric_brownian_markets : market list -> market list
val market_prices : market list -> float list
val simulate_history : market list -> market -> int -> market list
val simulate_history_with_market : market -> int -> market list
val pp_market : Format.formatter -> market -> unit
val pp_market_history : Format.formatter -> market list -> unit
