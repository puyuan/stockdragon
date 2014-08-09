#!/usr/bin/Rscript --restore --save
library(Rook)
R.server <- Rhttpd$new()


Rook.app <- function(env) {

    request <- Request$new(env)
    response <- Response$new()

    write.initial.HTML(response)

    response$finish()
}


write.article.HTML<-function(key, value, response){
    key<- as.numeric(key)
    response$write(sprintf("<h2><a href='%s' target=_blank>%s</a></h2>", data[key, 5], data[key,2]))
    response$write(sprintf("<p>%s</p>", data[key,3]))
    response$write("<pre>")
    response$write(data[key,4])
   response$write("</pre>")
}


write.initial.HTML <- function(response) {

    response$write('<link rel="stylesheet" type="text/css" href="css/custom.css"' )

    response$write("<h1>A Simple Web Application</h1>")
    response$write(paste("<i>***Times through the Rook.app function:", 3, 
        "***</i>"))
    mapply( write.article.HTML,key=names(rank_list[1:100]), value=rank_list[1:100], MoreArgs=list(response=response))
	
    response$write("<form method=\"POST\">")
    response$write("<h3>Icebreaker Survey</h3>")
    response$write("First name: <input type=\"text\" name=\"firstname\"><br><br>")
    response$write("Favorite number: <input type=\"text\" name=\"favnumber\"><br>")
    response$write("<h3>What do you want to do?</h3>")
    response$write("<input type=\"submit\" value=\"Generate Icebreaker from Survey\" name=\"submit_button\">")
    response$write("<button value=\"Plot\" name=\"iris_button\">Plot the Iris data set </button> <br>")

}
R.server$add(app = File$new(paste(getwd(),"/css", sep="")), name = "css")
R.server$add(app=Rook.app, name="query")
R.server$start()

while (TRUE) Sys.sleep(24 * 60 * 60)
