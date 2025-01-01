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
