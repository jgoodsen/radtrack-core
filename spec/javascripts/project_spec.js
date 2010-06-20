// var User = function() {
// 
// 
// }
// 
// var User.prototype.getUsersForProject = function(project) {
// 	// Ajax code to get users for project
// }
// 

	var Project = function(project_id) {

		// var users = [{id:44}];
		// 
		// this.init = function() {
		// 	this.ajaxGetUsersForProject();
		// }
		// 
		// // // Mock this out for JS unit tests
		// this.ajaxGetUsersForProject = function() {
		// // 	// $.post(
		// // 	// project_cards_url(project_id), {},
		// // 	// function(data, textStatus) {
		// // 	// 	users = data;
		// // 	// },
		// // 	// "json")
		// // }
		// // 
		// // this.Users = function() {
		// // 	return users;
		// }
		// 
		// // this.init();
	}
	// 
	  var Project.protodtype.ajaxGetUsersForProject = function() {
	
	}
	var CurrentProject = new Project(99)
	
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

		it('should ask the service for the project users on the first request', function() {
			var CurrentProject = new Project(99)
			CurrentProject.fn.ajaxGetUsersForProject = function() {
				return [{id:888}]
			}
			expect(CurrentProject.Users()).toEqual(users_json)
		});

		describe('nested describe', function() {
			it('should also have a passing test', function() {
				expect(true).toEqual(true);
			});
		});
	});
