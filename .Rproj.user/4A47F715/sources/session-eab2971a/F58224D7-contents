ent=function(data)
{
  data=data/rowSums(data)
  eata=log2(data)
  fata=eata %>% as.data.frame() %>% dplyr::mutate(across(.cols = everything(), ~ ifelse(is.infinite(.x), 0, .x)))
  return(-rowSums(data*fata))
}




plotTetrahedron=function(data,
                         entropyrange=c(0,Inf),
                         maxvaluerange=c(0,Inf),
                         col=c("red","green","blue","orange"),
                         labels=NULL,
                         output_table=F,remove_background=T,cex=1,pch=16,
                         title="",push_text=1.2,
                         margin=5)
{
  #require(dplyr)
  # data=y %>% select("POLR3A","POLR3GL","POLR3C","POLR3G") %>% slice_sample(n=500)
  # col=c("red","green","blue","orange")
  # normalized_magnituderange=c(0.01,1)
  # data=hmm;remove_background = T;normalized_magnituderange = c(0.001,1);output_table = T
  
  #Creating a Tetrahedron and finding center of mass
  {  
    data[data<0]=0
    vertices <- matrix(c( 1,  1,  1,
                           1, -1, -1,
                           -1,  1, -1,
                           -1, -1,  1), ncol = 3, byrow = TRUE)
  com_=data.frame(comx=rowSums(as.matrix(data)%*%diag(vertices[,1])),
                  comy=rowSums(as.matrix(data)%*%diag(vertices[,2])),
                  comz=rowSums(as.matrix(data)%*%diag(vertices[,3])))/rowSums(data)
  vertices11 = as.data.frame(vertices) %>% mutate(labels = colnames(data)) #for plotting vertex
  edges11=as.data.frame(vertices[c(1,2,3,1,4,2,3,4),]) #for plotting edges
  edge_color=rep("black",7)
  if(colnames(data)[1]=="NULL")
  {edge_color[c(1,3,4)]="transparent"
    col[1]="transparent"}
  final=cbind(data,com_)
  }##luka##
  
  #Finding entropy,magnitude,max value and color
  {  
    #Finding entropy and magnitude
    final=final %>% dplyr::mutate(entropy=ent(data))

    #Finding max value and assigning color on the basis of max value
    final=final %>% dplyr::mutate(max=apply(data,1,max)) %>% 
      dplyr::mutate(color=ifelse(.[[1]]==max,col[1],ifelse(.[[2]]==max,col[2],ifelse(.[[3]]==max,col[3],col[4]))))
  }##Luka##
  
  #Filtering on the basis of entropy, magnitude and max value
  {
    #Filtering on the basis of entropy
    final$color[!(final$entropy>=entropyrange[1] & 
                    final$entropy<=entropyrange[2])]="whitesmoke"
    
    #Filtering on the basis of maxvalue
    final$color[!(final$max>=maxvaluerange[1] & 
                    final$max<=maxvaluerange[2])]="whitesmoke"
    #Adding labels and colors
    if(is.null(labels)) 
    {print("No labels provided. Using rownames as labels");labels=rownames(final)}
    final=final %>% mutate(color=factor(color),labels=labels)  #factorizing color coz thats needed in plotly
  }##Luka##
  
  #Plotting
  {
    
    final_good= final %>% filter(color!="whitesmoke")
    if(remove_background==T) {final_bad=final %>% dplyr::slice()} else
    {   final_bad= final %>% filter(color=="whitesmoke")}
    
    p= plot_ly(
      data = vertices11,
      x = ~V1*1.5,y = ~V2*1.5,z = ~V3*1.5,  #multiplying by 1.5 to push away the vertices label
      type = 'scatter3d',mode = 'text',
      text = ~labels,textposition = 'top center',
      textfont = list(size = 20, color = col)
    ) %>%    ##Now adding background
      add_trace(
        data = final_bad ,
        x = ~comx,y = ~comy,z = ~comz,
        type = 'scatter3d',mode = 'markers+text',
        text = ~labels,textposition = 'top center',
        textfont = list(size = 10, color=~color,colors=col),
        marker = list(size = 10,color=~color,colors=col )
      )  %>%   ##Now adding frontground
      add_trace(
        data = final_good ,
        x = ~comx,y = ~comy,z = ~comz,
        type = 'scatter3d',mode = 'markers+text',
        text = ~labels,textposition = 'top center',
        textfont = list(size = 10, color=~color,colors=col),
        marker = list(size = 10,color=~color,colors=col )
      ) 
    
    # %>%   ##Now drawing the edges
    #   add_trace(
    #     data = edges11,
    #     x = ~V1,y = ~V2,z = ~V3,
    #     type = 'scatter3d',mode = 'lines+text',
    #     line = list(color = edge_color, width = 10),
    #     text=NULL
    #   )
    ##Now drawing edges one by one in 7 different layers(traces)
    for (i in 1:(nrow(edges11) - 1)) {
      p <- p %>% add_trace(
        x = edges11$V1[i:(i+1)],
        y = edges11$V2[i:(i+1)],
        z = edges11$V3[i:(i+1)],
        type = 'scatter3d',
        mode = 'lines+text',
        line = list(color = edge_color[i], width = 10),
        text=NULL
      )
    }
    

  }##Luka##
  
  #Returning table and plot
  if (output_table) {
    return(list(plot = p, table = final_good))  # `p` is the plotly object
  } else {
    return(p)
  }
  # if(output_table==T) return(final)
}##luka##
