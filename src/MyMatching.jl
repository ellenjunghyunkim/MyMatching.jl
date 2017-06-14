module MyMatching
    export my_deferred_acceptance
    function my_deferred_acceptance(m_prefs, f_prefs)
        num_m = length(m_prefs)
        num_f = length(f_prefs)
        f_matched = zeros(Int, num_f)
        #m_matched = zeros(4)
        m_unmatched = collect(1:num_m)
        m_pointers = ones(Int, num_m)
        while length(m_unmatched) > 0
        
        while length(m_unmatched) > 0
              m = m_unmatched[1]
              if length(m_prefs[m]) < m_pointers[m]
 -            println(m, " finished proposing", m_pointers[m], length(m_prefs[m]))
                  shift!(m_unmatched)
                  continue
              end
              f = m_prefs[m][m_pointers[m]]
 -            println(m, " proposes to ", f)
              if m in f_prefs[f] #if m is favorable to f
 -            println(f, " thinks ", m, " is favorable")
                  current_m = f_matched[f] 
                  if current_m == 0 #if f is not married
 -                println("because ", f, " is solitary, matched")
                      f_matched[f] = m
                      shift!(m_unmatched)
                      continue
                  elseif findfirst(f_prefs[f], current_m) > findfirst(f_prefs[f], m) #if m is more preferred
 -                println("because ", m, " is more preferred to ", current_m, ", matched")
                      f_matched[f] = m
                      m_unmatched[1] = current_m
                      m_pointers[current_m] += 1
                      continue
                  end
 -                println(m, " is less preferred to ", current_m)
              end
 -            println(m, "failed proposing")
              m_pointers[m] += 1
          end
        end
        m_matched = [findfirst(f_matched, i) for i in 1:num_m]
        return f_matched, m_matched
    end

end
