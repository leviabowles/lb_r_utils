## Monty Hall simulation game for variable number of games played, whether switch strategy is in play and variable numbers of doors

simulations = 10000
doors = 5
switcher = 1


monty_hall = function(simulations,doors,switcher){
    sim_matrix = matrix(nrow = simulations, ncol = doors, runif(simulations*doors))
    winners = apply(sim_matrix, 1, which.max)
    door = c(1:doors)
    chosen = sample(door,simulations, replace = TRUE)
    catch = c()
    for(i in c(1:simulations)){
        eliminate = sample(setdiff(door,c(chosen[i],winners[i])),1)
        if(switcher == 0){
            chosed = chosen[i]}else{
            chosed = sample(setdiff(door,c(eliminate,chosen[i])),1)}
        print(length(chosed))
        print(chosed)
        result = if(chosed == winners[i]){1}else{0}
        catch = c(result, catch)
    }
    summary(catch)
}

monty_hall(simulations, doors, switcher)

