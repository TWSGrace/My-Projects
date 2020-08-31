//Get Input from Player
key_left = keyboard_check(vk_left);
key_right = keyboard_check(vk_right);
key_up = keyboard_check(vk_up);
key_down = keyboard_check(vk_down);

//Define Horizontal & Vertical
h_move = key_right - key_left;
v_move = key_down - key_up;

//Make Diagonal speed same as horizontal/vertical & Set direction
if (h_move != 0 and v_move != 0) {
 var length = sqrt(h_move*h_move + v_move *v_move);
 target_direction = radtodeg(arctan2(-v_move, h_move));
 h_move /= length;
 v_move /= length;
}
else
{
	if v_move == 1 {target_direction = -90}
	if v_move == -1 {target_direction = 90}
	if h_move == 1 {target_direction = 0}
	if h_move == -1 {target_direction = 180}
}

//Only move if given input
if (h_move != 0 or v_move != 0) {walksp = 4}
else {walksp = 0}

if direction < 0 {direction += 360}
if direction > 360 {direction -= 360}
if target_direction < 0 {target_direction += 360}
if target_direction > 360 {target_direction -= 360}


//MAKE direction SLOWLY MOVE TOWARDS target_direction

direction_speed = 15
direction_change = direction - target_direction;
if direction_change > 180 {direction_change -= 360}
if direction_change < -180 {direction_change += 360}
if direction_change > 0 
{
	if direction_change < direction_speed {direction = target_direction}
	else {direction -= direction_speed}
}
if direction_change < 0
{
	if direction_change > -direction_speed {direction = target_direction}
	else {direction += direction_speed}
}


//Set Motion
motion_set(direction, walksp);

//Change Size of Beams
if keyboard_check(vk_shift) && count = 0 {beam_length++; count++;}
if count > 0 {count++;}
if count >= 10 {count = 0}
if beam_length >= 4 {beam_length = 1}


//Change angle of beams
if keyboard_check(ord("E")) {beam_angle--;}
if keyboard_check(ord("Q")) {beam_angle++;}
if beam_angle < 45 {beam_angle = 45;}
if beam_angle > 135 {beam_angle = 135}
//angle_min = direction - (beam_angle / 2);
//angle_max = direction + (beam_angle / 2);

//Create two lasers originating at Player and at different angles based on beam_angle
if keyboard_check_pressed(vk_space) == true
{
	laser1 = instance_create_layer(x + 5, y, "Player", oLaser)
	with (laser1)
	{
		image_angle = other.direction - 90 + (other.beam_angle / 2);
		image_xscale = -1;
		image_yscale = other.beam_length;
	}
	laser2 = instance_create_layer(x - 5, y, "Player", oLaser)
	with (laser2)
	{
		image_angle = other.direction - 90 - (other.beam_angle / 2);
		image_xscale = 1;
		image_yscale = other.beam_length;
	}
}

//Update beams
if keyboard_check(vk_space) && instance_exists(oLaser)
{
	with (laser1)
	{
		image_angle = other.direction - 90 + (other.beam_angle / 2);
		image_yscale = other.beam_length;
	}
	with (laser2)
	{
		image_angle = other.direction - 90 - (other.beam_angle / 2);
		image_yscale = other.beam_length;
	}
}








