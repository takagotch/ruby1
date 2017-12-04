
def fn(a)
  case a
  when 1
  when 5, 10
    puts "five or ten"
  when 20
    puts "twenty"
  else
    puts "other"
  end
end

fn(5)
fn(10)
fn(500)
