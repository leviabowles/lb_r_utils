days_in_year = 365
simulations =100000
library(ggplot2)

collision_serach = function(days_in_year){
    days = c(1:days_in_year)
    catcher = c()
    for(i in c(1:365)){
      ca = sample(days,1)
      catcher = c(ca,catcher)
     # print(i)
      if(length(unique(catcher)) != length(catcher))break
      }
    return(i)
}


simulate_rooms = function(simulations, days_in_year){
  simu = c(1:simulations)
  sim_out = c()
  for(j in simu){
    out = collision_serach(days_in_year)
    sim_out = c(out,sim_out)
  }
  return(sim_out)
  
}

xx = simulate_rooms(simulations,days_in_year )
xx = data.frame(simulations = xx)

ggplot2::ggplot(xx, aes(simulations))+
  geom_histogram(binwidth = 2)+
  ggtitle("People Until Birthday Collision")
