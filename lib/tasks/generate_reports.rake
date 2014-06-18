task :GEN_REPORT =>:environment do
	@projects = Project.all

	@projects && @projects.each do |project|
		report = project.reports.last
		if report.answers.where(status: [1,2,3]).present?
			report = project.reports.build
			report.name = "#{project.name} Report #{Date.today.to_s}"
			report.save!

			Question.all.each do |q|
		      report.answers.create!(question_id: q.id)
		    end
		else
			puts "report dosn't generate"
		end
	end
end
# Project.first.reports.last.answers.where(status: [1,2,3])
