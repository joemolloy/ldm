start.run <- function () {
  run.date <<- format(Sys.time(), "%Y-%m-%d-%H%M%S")
  run.folder <- paste("model", run.date, sep = "_")
  current.run.folder <<- file.path("canada/data/mnlogit/runs", run.folder) #<<- adds to global environment
  dir.create(current.run.folder)
  return (run.date)
}


alternatives <- as.data.frame(fread("canada/data/mnlogit/mnlogit_canada_alternatives2.csv"))
alternatives <- alternatives %>% select (alt, population, employment, alt_is_metro, d.lang = speak_french)

all_trips <- as.data.frame(fread("canada/data/mnlogit/mnlogit_all_trips2.csv"))
all_trips <- all_trips %>% rename(chid = id) %>%
  mutate( 
    daily.weight = wtep / (365 * 3),
    o.lang = alternatives[lvl2_orig,]$d.lang,
    purpose_season = paste(purpose, season, sep="_")
  )  #need to scale weight by number of years, and to a daily count


#load skim
f <- h5file("canada/data/mnlogit/cd_travel_times2.omx")
tt <- f["data/cd_traveltimes"]
cd_tt <- tt[]