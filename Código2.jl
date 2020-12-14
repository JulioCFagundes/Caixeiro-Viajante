using Printf, Plots
gr(size=(600,400))

using Clp
using JuMP
using GLPK
using CSV
using DataFrames
CSV.read("C:\\export_df.csv", DataFrame) ###isso está no meu computador, na pasta disco local C + nome do arquivo
CSV.File("C:\\export_df.csv"; normalizenames=true)
p = CSV.File("C:\\export_df.csv")
function PCV(p,gasolina,cpl,io::IO = stdout) ##p::os valores da tabela, gasolina::preço, cpl::quanto o caminhão faz por Litro
    m=length(p)
    s = rand(m,m)
    d = 0.0
    ç = 0.0
    for i = 1:m
        for j= 1:m
            if ((cos((90-p[i][2])/180pi))cos((90-p[j][2])/180pi) + sin((90-p[i][2])/180pi)sin((90-p[j][2])pi/180)cos((p[i][3]-p[j][3])pi/180)) > 1
                d = sqrt((p[i][2]-p[i][2])^2+(p[i][3]-p[j][3])^2)
                ç = 129.3799d -34.8839
                s[i,j] = ç
            else
                x = 6371acos((cos((90-p[i][2])/180pi))cos((90-p[j][2])/180pi) + sin((90-p[i][2])/180pi)sin((90-p[j][2])pi/180)cos((p[i][3]-p[j][3])pi/180))1.15
            # formula de Haversine, utiliza as leis do cossenos considerando o modelo a curvatura da terra onde o raio é 6371km
            # poderiamos também utilizar a formula m(x)=129.3799x -34.8839 que foi adquirida atraves de uma regressão linear
            # onde meu x erra a distancia entre pontos (no caso distancia entre latitudes e longitudes) e o meu y era a distancia em km
                s[i,j] = x
            end
        end
    end
    f = Model(with_optimizer(GLPK.Optimizer))
    @variable(f, x[1:m,1:m], Bin)
    @objective(f, Min, sum(x[i,j]*s[i,j] for i=1:m,j=1:m))
    for i=1:m
        @constraint(f, x[i,i] == 0)
        @constraint(f, sum(x[i,1:m]) == 1)
    end
    for j=1:m
        @constraint(f, sum(x[1:m,j]) == 1)
    end
    # for i = 1:m
    #    for j = 1:m
            #coloquei @constraint (f, sum(x[i,j]) <= (m-1)) 
    #    end
    #end 
    # mas ainda ocorreu de dar o X com sub-rota então coloquei ela no final.
    for i = 1:m, j = 1:m
        @constraint(f, x[i,j]+x[j,i] <= 1) # isso impede de que você passe pelo mesmo local, 
        #no caso impede que a matriz s não pegue mesmo valores na matriz distancia como os valores de x[i,j] e x[j,i] são os mesmo na matriz s
    end
    optimize!(f)
    km = 0.0
    custo = 0.0
    MatrizX = JuMP.value.(x)
    Solução = Int[] #inteiro por conta das entradas da matriz
    push!(Solução, 1.0)
    for i=1:m #1 é a empresa inicial
        indice = argmax(MatrizX[Solução[end],1:m]) #procura o maior valor #esta parte condicional 2 e 3
        if indice == Solução[1]
            break
        else
            push!(Solução,indice)
        end
    end
    if length(Solução) < m 
        @constraint(f, sum(x[Solução,Solução]) <= length(Solução)-1)
    end
    println(io, "|Cidades percorridas em ordem|     Km rodados     |    Custo da viajem   |")
    println(io, "|----------------------------|--------------------|----------------------|")
    println(io, "|  1                         |    0.0             |     0.0              |")
    for i=2:m
        km = km + s[Solução[i],Solução[i-1]] #s[1,2] 1 é saída e 2 a chegada
        custo = custo + ((gasolina/cpl)*km)
        ç = @sprintf("| %2d                         | %17.15lf|     %10.4e       |", Solução[i], km, custo)
        println(io,ç)  
    end 
    #tentamos fazer um plot do grafo das cidades e não conseguimos infelizmente.
end
