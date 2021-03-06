require "pstore"

class ProfileByPStore
  def initialize(idstr)
    @db = PStore.new(PROFILE_FILE)
    @id = idstr
  end

  def get
    @db.transaction do
      if @db.root?(@id)
        return @db[@id]
      else
        return Hash.new
      end
    end
  end

  def write(prof)
    @db.transaction do
      @db[@id] = prof
    end
  end
end
