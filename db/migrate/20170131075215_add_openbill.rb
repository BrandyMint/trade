class AddOpenbill < ActiveRecord::Migration[5.0]
  def up
    openbill_up
  end

  def down
    openbill_down
  end

  private

  def openbill_up
    Dir.entries(sql_dir).select{|f| File.file? sql_dir + f }.sort.each do |file|
      say_with_time "Migrate with #{file}" do
        execute File.read sql_dir + file
      end
    end
  end

  def openbill_down
    execute "DROP TABLE IF EXISTS OPENBILL_ACCOUNTS CASCADE"
    execute "DROP TABLE IF EXISTS OPENBILL_TRANSACTIONS CASCADE"
    execute "DROP TABLE IF EXISTS OPENBILL_GOODS CASCADE"
    execute "DROP TABLE IF EXISTS OPENBILL_GOODS_AVAILABILITIES CASCADE"
    execute "DROP TABLE IF EXISTS OPENBILL_CATEGORIES CASCADE"
    execute "DROP TABLE IF EXISTS OPENBILL_POLICIES CASCADE"
  end

  def openbill_reset
    openbill_down
    openbill_up
  end

  def sql_dir
    './db/openbill_sql/'
  end
end
