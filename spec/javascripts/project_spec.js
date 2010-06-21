describe('CurrentProject', function() {

	var users_json = [{
		id: 1,
		login: "admin@test.com",
		email: "admin@test.com",
		admin: true
	},
	{
		id: 2,
		login: "joe@test.com",
		email: "joe@test.com",
		admin: false
	},
	]

	beforeEach(function() {
		CurrentProject = new Project(99)
		spyOn(CurrentProject, "ajaxGetUsersForProject").andCallFake(function() {
			CurrentProject.users = users_json
		})
		CurrentProject.init()
	})

	it('should ask the service for the project users on the first request', function() {
		expect(CurrentProject.users).toEqual(users_json)
	});

	describe('nested describe', function() {
		it('should also have a passing test', function() {
			expect(true).toEqual(true);
		});
	});

});
