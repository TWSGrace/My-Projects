/// @description Insert description here
// You can write your code in this editor

//Move laser to stay in same position as player
with (oPlayer)
{
	other.x = x;
	other.y = y;
}

//Destroy Laser if space is released
if keyboard_check_released(vk_space)
{
	instance_destroy()	
}

image_speed= 0.2;
