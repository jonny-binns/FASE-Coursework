with Ada.Text_IO; use Ada.Text_IO;


Package body Aeroplane with SPARK_Mode is

--methods

--shut door
   procedure ShutDoor (d : in out door) is
   begin
      d.Status := closed;
      Put_Line("Door is: " & d.Status'Image);
   end ShutDoor;

--open door
  procedure OpenDoor (d : in out Door) is
  begin
      d.Status := open;
      Put_Line("Door is: " & d.Status'Image);
  end OpenDoor;

--lock door
  procedure LockDoor (d : in out Door) is
  begin
      d.Lock := locked;
      Put_Line("Door is: " & d.Lock'Image);
   end LockDoor;

--unlock door
  procedure UnlockDoor (d : in out Door) is
  begin
      d.Lock := unlocked;
      Put_Line("Door is: " & d.Lock'Image);
 end UnlockDoor;


   --set fuel
   procedure SetFuel (f : out FuelLevel; i : in FuelLevel) is
   begin
      f := i;
      Put_Line("Fuel is: " & f'Image & "% full");
   end SetFuel;


--take off
   procedure TakeOff ( p : in out Aeroplane) is
   begin
      p.Flight := takeOff;
      Put_Line("Flight set to" & p.Flight'Image);
   end TakeOff;


   --maintain normal flight
   procedure MaintainNormalFlight (p : in out Aeroplane) is
   begin
      --altitude
      while p.Altitude < 35000 loop
         p.Altitude := p.Altitude + 1;
         if p.Altitude mod 100 = 0 then
            Put_Line("Altitude: " & p.Altitude'Image & " ft");
         end if;
      end loop;
      while p.Altitude > 35000 loop
         p.Altitude := p.Altitude - 1;
         if p.Altitude mod 100 = 0 then
            Put_Line("Altitude: " & p.Altitude'Image & " ft");
         end if;
      end loop;

      --airspeed
      while p.AirSpeed < 933 loop
         p.AirSpeed := p.AirSpeed + 1;
         if p.Altitude mod 5 = 0 then
            Put_Line("Air Speed: " & p.AirSpeed'Image & " km/h");
         end if;
      end Loop;
      while p.AirSpeed > 933 loop
         p.AirSpeed := p.AirSpeed - 1;
         if p.Altitude mod 5 = 0 then
            Put_Line("Air Speed: " & p.AirSpeed'Image & " km/h");
         end if;
      end Loop;

      Put_Line("Altitude: " & p.Altitude'Image & " ft");
      Put_Line("Air Speed: " & p.AirSpeed'Image & " km/h");
   end MaintainNormalFlight;


   --flight status
   procedure FlightStatus (p : in Aeroplane) is
   begin
      Put_Line("Cockpit door is: " & p.CockpitDoor.Status'Image & " and " & p.CockpitDoor.Lock'Image);
      Put_Line("External doors are: " & p.ExternalDoor.Status'Image & " and " & p.ExternalDoor.Lock'Image);
      Put_Line("Flight stage: " & p.Flight'Image);
      Put_Line("Altitude: " & p.Altitude'Image & " ft");
      Put_Line("Air Speed: " & p.AirSpeed'Image & " km/h");
      if p.Fuel <= 20 then
         Put_Line("-------------------- WARNING FUEL LEVEL LOW --------------------");
      end if;
      Put_Line("Fuel: " & p.Fuel'Image & "%");

   end FlightStatus;


end Aeroplane;
