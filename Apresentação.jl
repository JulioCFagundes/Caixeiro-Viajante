using DataFrames
df = DataFrame(Name = ["Cidade 1","Cidade 2","Cidade 3","Cidade 4","Cidade 5"], 
               Latitude = [23,2323,232323,23232323,2323232323],
               Longitude = [2,2,2,2,2]
               )

using CSV
CSV.write("C:\\Users\\Julio\\Desktop\\Arquivo2.csv", df)


using CSV
using DataFrames

CSV.read("C:\\Users\\Julio\\Desktop\\Arquivo2.csv", DataFrame)
CSV.File("C:\\Users\\Julio\\Desktop\\Arquivo2.csv"; normalizenames=true)
f = CSV.File("C:\\Users\\Julio\\Desktop\\Arquivo2.csv")

dist = (ones(length(f), length(f)))

for i in 1:length(f) 
    for j in 1:length(f) 
        dist[i,j] = sqrt((f[i][2] - f[j][2])^2 + (f[i][3] - f[j][3])^2) 
    end
end
dist

MatrizCond = zeros(length(f),length(f))
x = 0
MatrizRota = []
Rota = [0]
RotaNome = []
for i in 1:length(f)
    for j in 1:length(f)
        if dist[i,j] == 0
            dist[i,j] = 2^63-1
        end
    end
end
###código acima deixou todas as distâncias de uma cidade até ela mesma como um número anterior ao Overflow, assim, o programa
###não pegará a distância de uma cidade até ela mesma 
y = []
for i in 1:length(f) -1     
    x = minimum(dist[1:length(f),i])
    for j in 1:length(f)
        
        for k in 1:length(RotaNome)
            for l in 1:length(f)
                if x == Rota[k]
                    dist[j,l] = 2^63-1
                    
                end
                x = minimum(dist[1:5,i])
            end
        end
            if x == dist[j,i]
                y = "Caminho = Cidade$(i)$(j)"
                
            end
    
            
        
    end
    RotaNome = push!(RotaNome,y )
    Rota = push!(MatrizRota,x)
    RotaNome = String.(RotaNome)
    Rota = Float64.(Rota)
end
println("Distâncias rota = $Rota, Cidades rota = $RotaNome")


dist


