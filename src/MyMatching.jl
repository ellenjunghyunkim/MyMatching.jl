module MyMatching
    export my_deferred_acceptance

    function my_deferred_acceptance(m_prefs, f_prefs)
        num_m = length(m_prefs)
        num_f = length(f_prefs)
        f_matched = zeros(Int, num_f)
        m_unmatched = collect(1:num_m)
        m_pointers = ones(Int, num_m)

        while length(m_unmatched) > 0
            m = m_unmatched[1]
            if length(m_prefs[m]) < m_pointers[m]
                shift!(m_unmatched)
                continue
            end
            f = m_prefs[m][m_pointers[m]]
            if m in f_prefs[f] #if m is favorable to f
                current_m = f_matched[f] 
                if current_m == 0 #if f is not married
                    f_matched[f] = m
                    shift!(m_unmatched)
                    continue
                elseif findfirst(f_prefs[f], current_m) > findfirst(f_prefs[f], m) #if m is more preferred
                    f_matched[f] = m
                    m_unmatched[1] = current_m
                    push!(m_unmatched, current_m)
                    continue
                end
            end
            m_pointers[m] += 1
        end

        m_matched = Int[findfirst(f_matched, i) for i in 1:num_m]
        return m_matched, f_matched
    end
end
