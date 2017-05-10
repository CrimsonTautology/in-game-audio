class WordFilter

  PROFANITY_FILTERS = [
    /fh?\W?[a@]h?\W?[g6]\W?[g6]+\W?[oeiau0]\W?t/i,
    /ph\W?[a@]\W?[g6]\W?[g6]+\W?[oeiau0]\W?t/i,
    /fh?[a@e]h?g+[szy]?\b/i,
    /ph[a@]g+[szy]?\b/i,
    /fgt[sz]?\b/i,
    /n\W?[i1]\s*[g6]\W?[g6]+\W?[eu3]\W?r/i,
    /n[i1][g6]+let/i,
    /\bn[i1][g6][g6]+[ay]s?\b/i,
    /\bnigs?\b/i,
    /\bspics?\b/i,
    /\bkikes?\b/i,
    /\bgooks?\b/i,
    /\bchinks?\b/i,
    /\braped?\b/i,
  ]

  def self.has_profanity? string
    return false if string.nil?
    string = string.gsub(/_|-/, " ")
    PROFANITY_FILTERS.any? {|filter| !!(string =~ filter)}
  end

end
