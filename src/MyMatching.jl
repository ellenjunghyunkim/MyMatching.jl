module MyMatching
    export my_deferred_acceptance_mm

    function my_deferred_acceptance_mm(prop_prefs::Matrix{Int},
                                   resp_prefs::Matrix{Int}, 
                                   caps::Vector{Int})
        num_prop = length(prop_prefs)
        num_resp = length(resp_prefs)
        
        prop_matched = zeros(Int,num_prop)
        resp_matched = zeros(Int, sum(caps))
        
        prop_pointers = ones(Int, num_prop)
        accept = zeros(Int,num_resp)
    #making indptr
        indptr = Array{Int}(num_resp+1)
        indptr[1] = 1
        for i in 1:num_resp
            indptr[i+1] = indptr[i] + caps[i]
        end
    #main loop
    
        for j in 1:num_resp
            for i in 1:num_prop
                if prop_matched[i] == 0 && prop_pointers[i] <= length(prop_prefs[i])
                k = prop_prefs[i][prop_pointers[i]]
                if findfirst(resp_prefs[k],i) != 0
                    if accept[k] < caps[k]
                        resp_matched[indptr[k+1]-1 - accept[k]]=i
                        prop_matched[i]=k
                        accept[k]+=1
                    
                    else
                        list= resp_matched[indptr[k]:indptr[k+1]-1]
                        ranking = zeros(Int, caps[k])
                        for j in j:caps[k]
                            ranking[j]= findfirst(resp_prefs[k],list(j))
                        end
                        if 0< findfirst(resp_prefs[k],i)<maximum(ranking)
                            resp_matched[indptr[k]+indmax(ranking)-1]=i
                            prop_matched[list[indmax(ranking)]]=0
                            prop_matched[i]=k
                        end
                    end
                end
                prop_pointers[i]+=1
            end
        end
    end
    return prop_matched, resp_matched, indptr
end

function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}})
    caps = ones(Int, length(resp_prefs))
    prop_matches, resp_matches, indptr =
        my_deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matches, resp_matches
end

export my_deferred_acceptance

end
