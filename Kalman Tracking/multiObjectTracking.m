function multiObjectTracking()
% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
obj = setupSystemObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    frame = readFrame(obj.reader);
    [centroids, bboxes, mask] = detectObjects(frame,obj.detector,obj.blobAnalyser);
    predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks, centroids);

    updateAssignedTracks(assignments);
    updateUnassignedTracks(unassignedTracks);
    deleteLostTracks(tracks);
    createNewTracks(nextId,unassignedDetections,centroids,bboxes,tracks);

    displayTrackingResults(frame,mask,tracks,obj.maskPlayer);
end

