# download in install ollama container 
```
apptainer pull docker://ollama/ollama
```

# run shell command apptainer
```
apptainer shell -B $TMPDIR:$TMPDIR -B /scratch/$USER:/scratch/$USER -B /project/xiaoyon/trustai/$USER:/project/xiaoyon/trustai/$USER --nv ollama_latest.sif
```
# start ollama
```
ollama serve & 
```

#download model
```
ollama pull llama3 
ollama run llama3
```
# Help and Doc
```
/? 
```

Make changes to the model like system prompt using the set command. 
```
/set system your system prompt
```

save and run the model with the new system prompt 


