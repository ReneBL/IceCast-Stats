FactoryGirl.define do

	factory :connection_24_hours_1_minute_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 24.hours - 1.minute).change(sec: 0))
		listeners 4
	end

	factory :connection_24_hours_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 24.hours).change(sec: 0))
		listeners 6
	end

	factory :connection_2_hours_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 2.hours).change(sec: 0))
		listeners 2
	end

	factory :connection_1_second_ago, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now - 1.second).change(sec: 0))
		listeners 8
	end

	factory :connection_1_second_above, class: ConnectionRealTime do
		datetime DateTime.evolve((DateTime.now + 1.minute).change(sec: 0))
		listeners 10
	end

end