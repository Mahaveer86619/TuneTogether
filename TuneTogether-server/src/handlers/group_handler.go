package handlers

import (
	"encoding/json"
	"net/http"

	impl "github.com/Mahaveer86619/TuneTogether_server/src/implementations"
	types "github.com/Mahaveer86619/TuneTogether_server/src/types"
)

func CreateGroupController(w http.ResponseWriter, r *http.Request) {
	var group types.GroupRequest
	err := json.NewDecoder(r.Body).Decode(&group)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_group, statusCode, err := impl.CreateGroup(&group)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_group)
	successResponse.SetMessage("Group created successfully")
	successResponse.JSON(w)
}

func GetAllGroupsController(w http.ResponseWriter, r *http.Request) {
	groups, statusCode, err := impl.GetAllGroups()
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(groups)
	successResponse.SetMessage("Groups fetched successfully")
	successResponse.JSON(w)
}

func GetAllPublicGroupController(w http.ResponseWriter, r *http.Request) {
	groups, statusCode, err := impl.GetAllPublicGroups()
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(groups)
	successResponse.SetMessage("Public groups fetched successfully")
	successResponse.JSON(w)
}

func GetGroupByIDController(w http.ResponseWriter, r *http.Request) {
	group_id := r.URL.Query().Get("id")
	if group_id == "" {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	returned_group, statusCode, err := impl.GetGroupByID(group_id)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_group)
	successResponse.SetMessage("Group fetched successfully")
	successResponse.JSON(w)
}

func UpdateGroupController(w http.ResponseWriter, r *http.Request) {
	var group types.GroupUpdateRequest
	err := json.NewDecoder(r.Body).Decode(&group)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_group, statusCode, err := impl.UpdateGroup(&group)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_group)
	successResponse.SetMessage("Group updated successfully")
	successResponse.JSON(w)
}

func DeleteGroupController(w http.ResponseWriter, r *http.Request) {
	group_id := r.URL.Query().Get("id")
	if group_id == "" {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := impl.DeleteGroup(group_id)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(nil)
	successResponse.SetMessage("Group deleted successfully")
	successResponse.JSON(w)
}

func GetAllGroupMembersController(w http.ResponseWriter, r *http.Request) {
	group_id := r.URL.Query().Get("id")
	if group_id == "" {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	groupMembers, statusCode, err := impl.GetGroupMembers(group_id)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(groupMembers)
	successResponse.SetMessage("Group members fetched successfully")
	successResponse.JSON(w)
}

func AddMemberToGroupController(w http.ResponseWriter, r *http.Request) {
	var groupMember types.GroupMemberJoinRequest
	err := json.NewDecoder(r.Body).Decode(&groupMember)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := impl.AddGroupMember(&groupMember)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(nil)
	successResponse.SetMessage("Member added to group successfully")
	successResponse.JSON(w)
}

func UpdateGroupMemberController(w http.ResponseWriter, r *http.Request) {
	var groupMember types.GroupMemberUpdateRequest
	err := json.NewDecoder(r.Body).Decode(&groupMember)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := impl.UpdateGroupMember(&groupMember)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(nil)
	successResponse.SetMessage("Member updated successfully")
	successResponse.JSON(w)
}

func RemoveMemberFromGroupController(w http.ResponseWriter, r *http.Request) {
	group_id := r.URL.Query().Get("group_id")
	user_id := r.URL.Query().Get("user_id")
	if group_id == "" || user_id == "" {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: group_id and user_id are required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := impl.DeleteGroupMember(group_id, user_id)
	if err != nil {
		failureResponse := types.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &types.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(nil)
	successResponse.SetMessage("Member removed successfully")
	successResponse.JSON(w)
}