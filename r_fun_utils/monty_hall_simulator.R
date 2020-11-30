simulations = 1000000
doors = 3
switcher = 0

sim_matrix = matrix(nrow = simulations, ncol = doors, runif(simulations*doors))
winners = apply(sim_matrix, 1, which.max)
door = c(1:doors)
chosen = sample(door,simulations, replace = TRUE)
catch = c()
for(i in c(1:simulations)){
    eliminate = sample(setdiff(door,c(chosen[i],winners[i])),1)
    if(switcher == 0){chosed = chosen[i]}else{chosed = setdiff(door,c(eliminate,chosen[i]))}
    result = if(chosed == winners[i]){1}else{0}
    catch = c(result, catch)
}
summary(catch)