//Work out direction Slime is from Player and distance from Player
//Find angle of beams
with (oPlayer)
{
	slime_direction = point_direction(x, y, other.x, other.y);
	slime_distance = point_distance(x, y, other.x, other.y);
	other.slime_direction = slime_direction;
	other.slime_distance = slime_distance;
	other.player_lasers = beam_length * 128;
	other.angle_min = direction - (beam_angle / 2);
	other.angle_max = direction + (beam_angle / 2);
}

//Set angle of beams to positive values
if angle_min < 0 {angle_min += 360}
if angle_max < 0 {angle_max += 360}
//Make sure angle_min is the actual minimum
if angle_min > angle_max {temp = angle_max; angle_max = angle_min; angle_min = temp}
//If the difference between your angles is greater than 180, move the max so that the difference is the smaller
if (angle_max - angle_min) > 180 {angle_max -= 360}
//Rechec minimum is minimum
if angle_min > angle_max {temp = angle_max; angle_max = angle_min; angle_min = temp}
//Check that slime_direction is within the angles
if (slime_direction - 360) > angle_min && (slime_direction - 360) < angle_max {slime_direction -= 360}
if (slime_direction + 360) > angle_min && (slime_direction + 360) < angle_max {slime_direction -= 360}

//If Slime is within correct distance and angle - Update direction of slime and set it's motion
if (dir_count == 0)
{
	if (angle_min <= slime_direction) && (slime_direction <= angle_max) && (slime_distance < player_lasers) && (instance_nearest(x, y, oLaser) != noone)
	{
		direction = oPlayer.direction + random_range(-10, 10);
		dir_count++; 
		motion_set(direction, speed);
	}
	else {speed = 0}
}

clamp(speed, 5, 20)

//Only update direction every 30 frames
//However update speed every frame and change direction minutely
if dir_count > 0 {dir_count++; speed = 200 / slime_distance; direction += random_range(-10, 10)}
if dir_count > 30 {dir_count = 0}

