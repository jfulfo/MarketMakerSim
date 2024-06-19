type order_side
type order_instruction
type order
type order_book

val order_book_empty : order_book
val add_order : order_book -> order -> order_book

(* Generate order use a laplace distribution to generate the price and the quantity based on the current price *)
(* We also randomly choose the side of the order *)
val generate_limit_order : float -> float -> order

(* In the same vein, we initialize the order book with a certain number of orders *)
val initialize_order_book : int -> float -> float -> order_book
val match_orders : order_book -> order_book
val pp_order : Format.formatter -> order -> unit
val pp_order_book : Format.formatter -> order_book -> unit
