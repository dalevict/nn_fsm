Compile `nn_components.v` and `nn_components_tb.v`:
`iverilog -o nn_sim nn_components.v nn_components_tb.v`

Run `nn_components_tb.v`:
`vvp nn_sim`