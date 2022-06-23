## Getting Zero Weight Interactions

# code to get edgelist
edge_list = tidygraph::activate(network, edges) |>
  as_tibble()

# assign a number to each individual
fish_data$num_id = seq(nrow(fish_data))

# attach the fish ids to the edgelist
fd = fish_data |>
  select(id, num_id)

edge_list = left_join(edge_list, fd, by = c("from" = "num_id")) |>
  left_join(fd, by = c("to" = "num_id"))

# add dyad id
edge_list$dyad_id = sprintf("%s-%s", edge_list$id.x, edge_list$id.y)

edge_list = select(
  edge_list, -from, -to
)

# join with theoretical
edge_list = right_join(
  edge_list, unique_pairs, by = "dyad_id"
)

# select useful cols
edge_list = select(edge_list, from, to, dyad_id, weight)

# assign 0 is weight is NA, ie, no interaction
edge_list = mutate(
  edge_list,
  weight = ifelse(test = is.na(weight), yes = 0, no = weight)
)
