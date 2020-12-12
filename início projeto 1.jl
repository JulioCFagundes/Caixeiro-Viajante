using CSV
using DataFrames
df = DataFrame(Name = ["Cidade 1","Cidade 2","Cidade 3","Cidade 4","Cidade 5"], 
               Latitude = [23,2323,232323,23232323,2323232323],
               Longitude = [2,2,2,2,2]
               )
##Cria o DataFrame

CSV.write("C:\\Users\\Julio\\Desktop\\ArquivoCidades.csv", df)

