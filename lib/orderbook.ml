(* Now we have to simulate an order book for our market *)
open Market
module OrderMap = Map.Make (Int)
module FloatMap = Map.Make (Float)

(* We will use pairing heaps to store the orders *)

type order_side =
  | Buy
  | Sell

type order_instruction =
  | Limit
  | Market
  | Stop

type order =
  { id : int
  ; side : order_side
  ; price : float
  ; quantity : float
  ; instruction : order_instruction
  ; timestamp : float
  }

let order_cmp (a : order) (b : order) : int =
  if a.price = b.price
  then
    if a.timestamp = b.timestamp then 0 else if a.timestamp < b.timestamp then -1 else 1
  else if a.side = Buy
  then if a.price > b.price then -1 else 1
  else if a.price < b.price
  then -1
  else 1
;;

type order_book =
  { bids : order Pairing_heap.t
  ; asks : order Pairing_heap.t
  ; stops : order list FloatMap.t
  ; map : order OrderMap.t
  }

let empty_order_book =
  { bids = Pairing_heap.create ~cmp:order_cmp ()
  ; asks = Pairing_heap.create ~cmp:order_cmp ()
  ; stops = FloatMap.empty
  ; map = OrderMap.empty
  }
;;

let add_order (book : order_book) (order : order) : order_book =
  if order.instruction = Market
  then raise (Invalid_argument "add_order: Market orders are not sent to the order book")
  else (
    let book = { book with map = book.map |> OrderMap.add order.id order } in
    match order.side with
    | Buy ->
      Pairing_heap.add book.bids order;
      book
    | Sell ->
      Pairing_heap.add book.asks order;
      book)
;;

(* We model the orders with a Laplace distribution over price and quantity *)
let generate_limit_order (market : market) : order = failwith "Not implemented"

let initialize_order_book (market : market) (n : int) : order_book =
  failwith "Not implemented"
;;

let match_orders (book : order_book) : order_book = failwith "Not implemented"

(* We can just make them into market orders once their price is hit *)
(* Loop through all stops, if it is a Sell and stop price is geq price then market sell
   opposite for buy side*)
let check_stop_orders (book : order_book) (price : float) : order_book =
  let rec check_orders orders =
    match orders with
    | [] -> []
    | order :: rest ->
      if order.side == Buy && price >= order.price
      then check_orders rest (* This will be replaced by a market order dispatch *)
      else if order.side == Sell && price <= order.price
      then check_orders rest
      else order :: check_orders rest
  in
  (* Now we fold over the stop orders and make the value check_orders orders *)
  book
  |> FloatMap.fold
       (fun price orders book ->
         let new_orders = check_orders orders in
         if new_orders = []
         then { book with stops = book.stops |> FloatMap.remove price }
         else
           { book with
             stops =
               book.stops |> FloatMap.update price (Option.map (fun _ -> new_orders))
           })
       book.stops
;;

let pp_order (fmt : Format.formatter) (order : order) : unit =
  Format.fprintf
    fmt
    "Order %d: %s %s %f %f %f"
    order.id
    (match order.side with
     | Buy -> "Buy"
     | Sell -> "Sell")
    (match order.instruction with
     | Limit -> "Limit"
     | Market -> "Market"
     | Stop -> "Stop")
    order.price
    order.quantity
    order.timestamp
;;

let pp_order_book (fmt : Format.formatter) (order_book : order_book) : unit =
  Format.fprintf
    fmt
    "Order Book:\n\t%d bids\n\t%d asks\n\t%d stops"
    (Pairing_heap.length order_book.bids)
    (Pairing_heap.length order_book.asks)
    (FloatMap.cardinal order_book.stops)
;;
