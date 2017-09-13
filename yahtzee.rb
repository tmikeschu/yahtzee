#problem to address: deleting one number from an array and not repetitions of it

class YahtzeeGame
  def initialize
    @yahtzee_hands_unplayed = ["ones", "twos", "threes", "fours", "fives", "sixes", 
                               "three of a kind", "four of a kind", "full house", 
                               "small straight", "large straight", "yahtzee", "chance"]
    @yahtzee_hands_played = {}
    @roll_count = 0
    @master_array = []
    @point_total = 0
    @singles_total = 0
    start
  end
  def start
    puts "\n Welcome to Yahtzee! Press enter to begin!"
    user_roll = gets.chomp.downcase
    if user_roll == ""
      puts "\n Let's do this!"
      roll
    else
      puts "\n Error."
      start
    end
  end
  def roll
    if @roll_count == 3 
      puts "\n You are out of rolls!"
      choice 
    else
      @array = []

      (5 - @master_array.length).times do |n| 
        n = rand(6) + 1
        @array << n
      end
      @roll_count += 1
      puts "\n * Turn #{@yahtzee_hands_played.count + 1} of 13 *"
      puts "\n Roll #{@roll_count}: You rolled: #{@array}"
      @array 
      response_prompt_1 if @roll_count == 1
      response_prompt_2 if @roll_count == 2
      choice if @roll_count == 3
    end
  end
  def response_prompt_1
    puts "\n Do you want to (h)old, (r)oll, or (p)lay a hand? (Enter the letter in parentheses)"
    user_response = gets.chomp.downcase
    if user_response == "h"
      hold
    elsif user_response == "r"
      roll
    elsif user_response == "p"
      choice
    else
      puts "\n Please enter Y or N"
      response_prompt_1
    end
  end
  def response_prompt_2
    puts "\n Do you want to (re)turn, (h)old, (r)oll, or (p)lay a hand? ?"
    user_response = gets.chomp.downcase
    if user_response == "re"
      return_hold
    elsif user_response == "h"
      hold
    elsif user_response == "r"
      roll
    elsif user_response == "p"
      choice
    else   
      puts "\n Error."
      response_prompt_2
    end
  end

  def hold
    keep_number = nil
    keep_array = [] 
    hold_arr = []
    puts "\n Which number(s) do you want to keep? (Enter one at a time, press enter when finished)"
    p @array
    while keep_number != "".to_i
      keep_number = gets.chomp.to_i
      keep_array << keep_number
    end
    keep_array.pop 
    keep_array.each do |n|
      if @array.include?(n)
        hold_arr << n
        @array.delete_at(@array.index(n))
      else
        puts "\n There are no more #{n}'s to hold!"
        p hold_arr
        p @array
        hold
      end  
    end
    @master_array << hold_arr && @master_array.flatten!
    puts "Your hand: #{@master_array}"
    if @master_array.length == 5
      choice
    else
      roll
    end
  end
  def return_hold
    return_array = []
    user_response = nil
    puts "\n Which numbers do you want to return? Enter one at a time and press enter when finished."
    while user_response != "".to_i
      user_response = gets.chomp.to_i
      return_array << user_response    
    end    
    return_array.pop 
    return_array.each do |n|
      if @master_array.include?(n)
        @master_array.delete_at(@master_array.index(n))
        @array << n
      else
        puts "\n #{n} is not one of your numbers!"
        p @master_array
        p @array
        return_hold
      end 
    end
    puts "Your hand: #{@master_array}"
    puts "Your roll: #{@array}"
    response_prompt_1
  end
  def no_hold
    puts "\n Do you want to ROLL or PLAY a hand?"
    user_response = gets.chomp.downcase
    if user_response == "roll"
    elsif user_response == "play"
      choice
    else
      "Please enter 'roll' or 'play'"
      no_hold
    end
  end
  def choice
    @master_array << @array if @master_array.length != 5
    @array = nil
    @master_array.flatten! 
    puts "\n Your hand: #{@master_array}"
    puts "\n What hand would you like to play?"
    p @yahtzee_hands_unplayed
    user_hand = gets.chomp.downcase
    if @yahtzee_hands_unplayed.include?(user_hand)
      @yahtzee_hands_unplayed.delete(user_hand.to_s)
      @yahtzee_hands_played[user_hand] = points(user_hand)
      @point_total += points(user_hand)
      @singles_total += points(user_hand) if user_hand == "ones" || user_hand == "twos" || 
        user_hand == "threes" || user_hand == "fours" || user_hand == "fives" || user_hand == "sixes"
      puts points(user_hand) == 1 ? "\n You played #{user_hand} for 1 point." : "\n You played #{user_hand} for #{points(user_hand)} points."
      puts @point_total == 1? "\n You have 1 point, and #{@yahtzee_hands_unplayed.count} turns left!" : "\n You have #{@point_total} points, and #{@yahtzee_hands_unplayed.count} turns left!"
      puts "\n You have #{@singles_total} points in the singles category." 
      puts @singles_total < 63 ? " Score #{63 - @singles_total} more for a bonus!" : "Nice, you got the 35-point bonus!"
      puts "\n Hands played: #{@yahtzee_hands_played}."
      puts "\n Hands remaining: #{@yahtzee_hands_unplayed}"
      @roll_count = 0
      @master_array = []
      if @yahtzee_hands_unplayed.count == 0
        game_over
      else
        print "\n Press enter to continue > "
        user_response = gets.chomp
        roll if user_response == ""
      end
    elsif @yahtzee_hands_played.include?(user_hand)
      puts "\n You already played that hand!"
      choice
    else
      puts "\n That's not a valid hand."
      choice
    end
  end
  def points(hand)
    points = 0
    case hand
    when "ones"
      @master_array.each { |n| points += n if n == 1 }
    when "twos"
      @master_array.each { |n| points += n if n == 2 }
    when "threes"
      @master_array.each { |n| points += n if n == 3 }
    when "fours"
      @master_array.each { |n| points += n if n == 4 }
    when "fives"
      @master_array.each { |n| points += n if n == 5 }
    when "sixes"
      @master_array.each { |n| points += n if n == 6 }
    when "three of a kind"
      @master_array.each {|n| points += n} if @master_array.uniq.count <= 3    
    when "four of a kind"
      @master_array.each {|n| points += n} if @master_array.uniq.count <= 2    
    when "full house"
      points += 25 if (@master_array.uniq.count <=2 && @master_array.count(@master_array[0]) != 4)
    when "small straight"
      points += 30 if @master_array.uniq.sort == [1,2,3,4] || @master_array.uniq.sort == [2,3,4,5] || @master_array.uniq.sort == [3,4,5,6] || 
        @master_array == [1,2,3,4,5] || @master_array == [2,3,4,5,6] || 
        @master_array == [1,2,3,4,6] || @master_array == [1,3,4,5,6]
    when "large straight"
      points += 40 if @master_array.sort == [1,2,3,4,5] || @master_array.sort == [2,3,4,5,6]
    when "yahtzee"
      points += 50 if @master_array.uniq.count == 1
    when "chance"
      @master_array.each { |n| points += n }
    end
    points
  end

  def game_over
    bonus
    puts "Game over."
    if @singles >= 63
      puts "You scored #{@point_total} points, and earned the 35-point singles bonus."
      @point_total += 35
      puts "Your final score is #{@point_total} points. Good job!"
    else
      puts "You scored #{@point_total} points. Good job!"
    end
    puts "Thank you for playing!"
    exit
  end
end

YahtzeeGame.new

=begin
Yahtzee pseudo code
(while loop? while hands_used < 12)
roll five random numbers after user presses enter
allow user to select holds if desired
store new array with held numbers
press enter to roll the < 5 - held > dice again
repeat hold selection
push new held number(s) to new array
repeat roll
prompt which hands are possible
ask for hand selection
mark hand as completed
=end

