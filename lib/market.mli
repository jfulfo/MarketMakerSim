type market_type =
  { price : float
  ; volatility : float
  ; drift : float
  ; dt : float
  }

type market_history

val geometric_brownian : market_type -> market_type
val geometric_brownian_markets : market_type list -> market_type list
val market_prices : market_type list -> float list
val simulate_history : market_type list -> market_type -> int -> market_history
val simulate_history_with_market : market_type -> int -> market_history
val pp_market : market_type -> string
val pp_history : market_history -> string
