with Ada.Text_IO; use Ada.Text_IO;


Package body Aeroplane with SPARK_Mode is

   --methods

   --set fuel level to desired point
   procedure SetFuelLevel (f : out FuelLevelMeasure; flevel : in FuelLevelMeasure; fmin : in FuelLevelMeasure) is
   begin
      f := flevel;
      Put_Line("Fuel is now set to: "& f'Image &"%");
   end SetFuelLevel;

   --close door
   procedure CloseDoor(d : out DStatus; f : in FlightStage) is
   begin
      d := closed;
      Put_Line("Door is now "& d'Image);
   end CloseDoor;

   --open door
   procedure OpenDoor(d : out DStatus; f : in FlightStage) is
   begin
      d := open;
      Put_Line("Door is now "& d'Image);
   end OpenDoor;

   --lock door
   procedure LockDoor(d : out DLock; f : in FlightStage) is
   begin
      d := locked;
      Put_Line("Door is now "& d'Image);
   end LockDoor;

   --unlock door
   procedure UnlockDoor(d : out DLock; f : in FlightStage) is
   begin
      d := unlocked;
      Put_Line("Door is now "& d'Image);
   end UnlockDoor;

   --turn off engine
   procedure EngineOff (e: out EngineStatus; f : in FlightStage) is
   begin
      e := off;
      Put_Line("Engine is now "& e'Image);
   end EngineOff;

   --turn on engine
   procedure EngineOn (e: out EngineStatus; f : in FlightStage) is
   begin
      e := on;
      Put_Line("Engine is now "& e'Image);
   end EngineOn;

   --turn off engine
   procedure LGearDown (g: out LandingGearPos; f : in FlightStage) is
   begin
      g := down;
      Put_Line("Landing gear is now "& g'Image);
   end LGearDown;

   --turn on engine
   procedure LGearUp (g: out LandingGearPos; f : in FlightStage) is
   begin
      g := up;
      Put_Line("Landing gear is now "& g'Image);
   end LGearUp;


   --set stationary mode
      procedure SetStationary(fmode: out FlightStage; al : in AltitudeRange; as : in AirSpeedRange) is
   begin
      fmode := stationary;
      Put_Line("Plane is in "& fmode'Image);
   end SetStationary;

   --set tow mode
   procedure SetTowMode(fmode: out FlightStage; d1 : in Door; d2 : in Door; e : in EStatus) is
   begin
      fmode := tow;
      Put_Line("Plane is in "& fmode'Image);
   end SetTowMode;

   --set takeoff mode
   procedure SetTakeOff(fmode: out FlightStage; d1 : in Door; d2 : in Door; f : in FuelLevelMeasure; fmin : in FuelLevelMeasure; a : in AltitudeRange; lg : in out LandingGearPos) is
   begin
      fmode := takeOff;
      if a <= 10000 then
         lg := down;
      end if;
     Put_Line("Plane is in " & fmode'Image &" mode, the altitude is: " & a'Image &" ft, the landing gear is " & lg'Image);
   end SetTakeOff;

   --set normal mode
   procedure SetNormal (fmode : in out FlightStage; as : in AirSpeedRange; al : in AltitudeRange) is
   begin
      fmode := normal;
   end SetNormal;

   --maintain normal flight
   procedure MaintainNormalFlight (fmode : in FlightStage; as : in out AirSpeedRange; al : in out AltitudeRange) is
   begin
      while as /= 935 loop
         if as > 935 then
            as := as - 1;
         end if;
         if as < 935 then
            as := as + 1;
         end if;
         if as mod 5 = 0 then
            Put_Line("Air Speed: "& as'Image &"km/h");
         end if;
      end loop;

      while al /= 35000 loop
         if al > 35000 then
            al := al - 1;
         end if;
         if al < 35000 then
            al := al + 1;
         end if;
         if al mod 5000 = 0 then
            Put_Line("Altitude: "& al'Image &"ft");
         end if;
      end loop;
   end MaintainNormalFlight;

   --landing
   procedure SetLanding(fmode : in out FlightStage; al : in AltitudeRange; lg : in out LandingGearPos) is
   begin
   fmode := landing;
      if al <= 10000 then
         lg := down;
      end if;
     Put_Line("Plane is in " & fmode'Image &" mode, the altitude is: " & al'Image &" ft, the landing gear is " & lg'Image);
   end SetLanding;

   --manual
   procedure SetManual(fmode : out FlightStage; d1light : in WarningLight; d2light : in WarningLight; flight : in WarningLight; allight : in WarningLight; aslight : in WarningLight; lglight : in WarningLight; elight : in WarningLight) is
   begin
      fmode := manual;
   end SetManual;


   --flight status
   procedure FlightStatus (p : in out PlaneRec) is
   begin
      --check status of variables
      --if status != stationary, doors need to be shut and locked, otherwise flash light
      if p.Flight /= stationary and (p.CockpitDoor.Status = open or p.CockpitDoor.Lock = unlocked) then
         p.CockpitDoor.Light := FLASHING;
      end if;

      if p.flight /= stationary and (p.ExternalDoor.Status = open or p.ExternalDoor.Lock = unlocked) then
         p.ExternalDoor.Light := FLASHING;
      end if;

      --if fuel level > 20 light off, <= 20 amber, <= 10 red, <=5 flash
      if p.Fuel.Level > 20 then
         p.Fuel.Light := off;
      elsif p.Fuel.Level <= 20 and p.Fuel.Level >=11 then
         p.Fuel.Light := AMBER;
      elsif p.Fuel.Level <= 10 and p.Fuel.Level >=6 then
         p.Fuel.Light := RED;
      else
         p.Fuel.Light := FLASHING;
      end if;

      --if status normal altitude between 3250 - 3750 off, between 30-3250/3750-40 amber, between 25-30/40-45 red, >25 or <45 flash
      if p.Flight = normal and (p.Altitude.Altitude >= 32500 and p.Altitude.Altitude <= 37500) then
         p.Altitude.Light := off;
      elsif p.Flight = normal and ((p.Altitude.Altitude >= 30000 and p.Altitude.Altitude <32500) or (p.Altitude.Altitude >37500 and p.Altitude.Altitude <= 40000)) then
         p.Altitude.Light := AMBER;
      elsif p.Flight = normal and ((p.Altitude.Altitude >= 25000 and p.Altitude.Altitude <30000) or (p.Altitude.Altitude >40000 and p.Altitude.Altitude <= 45000)) then
         p.Altitude.Light := RED;
      elsif p.Flight = normal then
         p.Altitude.Light := FLASHING;
      end if;

      if p.Flight /= normal then
         p.Altitude.Light := off;
      end if;

      --airspeed control
      if p.Flight = normal and (p.AirSpeed.Speed >= 930 and p.AirSpeed.Speed <= 940) then
         p.AirSpeed.Light := off;
      elsif p.Flight = normal and ((p.AirSpeed.Speed >= 920 and p.AirSpeed.Speed <930) or (p.AirSpeed.Speed >940 and p.AirSpeed.Speed <= 950)) then
         p.AirSpeed.Light := AMBER;
      elsif p.Flight = normal and ((p.AirSpeed.Speed >= 910 and p.AirSpeed.Speed <920) or (p.AirSpeed.Speed >950 and p.AirSpeed.Speed <= 960)) then
         p.AirSpeed.Light := RED;
      elsif p.Flight = normal then
         p.AirSpeed.Light := FLASHING;
      end if;

      if p.Flight /= normal then
         p.AirSpeed.Light := off;
      end if;

      --if status normal landing gear up,
      if p.Flight = normal and p.LandingGear.Position = up then
         p.LandingGear.Light := off;
      elsif p.Flight = normal and p.LandingGear.Position = down then
         p.LandingGear.Light := FLASHING;
      end if;

      --if status tow/stationary landing gear down,
      if (p.Flight = stationary or p.Flight = tow) and p.LandingGear.Position = up then
         p.LandingGear.Light := FLASHING;
      elsif (p.Flight = stationary or p.Flight = tow) and p.LandingGear.Position = down then
         p.LandingGear.Light := off;
      end if;

      --if takeoff and up light amber, if takeoff down above value flash
      if p.Flight = takeOff and p.Altitude.Altitude <= 10000 and p.LandingGear.Position = up then
         p.LandingGear.Light := FLASHING;
      elsif p.Flight = takeOff then
         p.LandingGear.Light := AMBER;
      end if;

      --if landing up amber, if landing below value and up down
      if p.Flight = landing and p.Altitude.Altitude <= 10000 and p.LandingGear.Position = up then
         p.LandingGear.Light := FLASHING;
      elsif p.Flight = landing then
         p.LandingGear.Light := AMBER;
      end if;

      --if status tow engine off, otherwise flash
      if p.Flight = tow and p.Engine.Status = on then
         p.Engine.Light := FLASHING;
      elsif p.Flight = tow and p.Engine.Status = off then
         p.Engine.Light := off;
      end if;


      --if status not tow and engine off flash
      if (p.Flight = takeOff or p.Flight = normal or p.Flight = landing) and p.Engine.Status = off then
         p.Engine.Light := FLASHING;
      else
         p.Engine.Light := off;
      end if;


      --if manual mode then turn lights off
      if p.Flight = manual then
         p.CockpitDoor.Light := off;
         p.ExternalDoor.Light := off;
         p.Fuel.Light := off;
         p.Altitude.Light := off;
         p.AirSpeed.Light := off;
         p.LandingGear.Light := off;
         p.Engine.Light := off;
      end if;


      --decide what to print
      Put_Line("System report:");
      --flight stage
      Put_Line("Flight stage: " & p.Flight'Image);

      --cockpit door
      if p.CockpitDoor.Light = FLASHING then
         Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("Cockpit Door is: " & p.CockpitDoor.Status'Image  & " and " & p.CockpitDoor.Lock'Image & " the warning light is: " & p.CockpitDoor.Light'Image);

      --external door
      if p.ExternalDoor.Light = FLASHING then
         Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("External Door is: " & p.ExternalDoor.Status'Image  & " and " & p.ExternalDoor.Lock'Image & " the warning light is: " & p.ExternalDoor.Light'Image);

      --Fuel
      if p.Fuel.Light = FLASHING or p.Fuel.Light = RED then
         Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("Fuel is at: " & p.Fuel.Level'Image & "% the warning light is: " & p.Fuel.Light'Image);

      --Altitude
      if p.Altitude.Light = FLASHING or p.Altitude.Light = RED then
         Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("Altitude is: " & p.Altitude.Altitude'Image & " ft the warning light is: " & p.Altitude.Light'Image);

      --AirSpeed
      if p.AirSpeed.Light = FLASHING or p.AirSpeed.Light = RED then
          Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("Air Speed is: " & p.AirSpeed.Speed'Image & " km/h the warning light is: " & p.AirSpeed.Light'Image);

      --LandingGear
      if p.LandingGear.Light = FLASHING then
          Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("Landing Gear is: " & p.LandingGear.Position'Image & " the warning light is: " & p.LandingGear.Light'Image);

      --Engine
      if p.Engine.Light = FLASHING then
          Put_Line("-----------------WARNING-----------------");
      end if;
      Put_Line("Engine is: " & p.Engine.Status'Image & " the warning light is: " & p.Engine.Light'Image);
  end FlightStatus;


   --system checker
   procedure SystemCheck (p : in out PlaneRec) is
   begin
      --explanation
      Put_Line("-----------------System Check Commencing-----------------");
      Put_Line("This process will test warning lights are functional by methodically activating each light");
      Put_Line("Plane settings will be restored to default after finishing");
      Put_Line("");

      --Cockpit door check
      Put_Line("-----------------Checking Cockpit Door-----------------");
      Put_Line("Light off:");
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light FLASHING:");
      p.CockpitDoor.Light := FLASHING;
      FlightStatus(p);
      p.CockpitDoor.Light := off;
      Put_Line("");

      --External doors check
      Put_Line("-----------------Checking External Doors-----------------");
      Put_Line("Light off:");
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light FLASHING:");
      p.ExternalDoor.Light := FLASHING;
      FlightStatus(p);
      p.ExternalDoor.Light := off;
      Put_Line("");

      --Fuel, off, amber, red, flashing
      Put_Line("-----------------Checking Fuel Light-----------------");
      Put_Line("WARNING: Fuel level reding will change during test");

      Put_Line("Light off:");
      p.Fuel.Level := 100;
      FlightStatus(p);

      Put_Line("Light Amber:");
      p.Fuel.Level := 20;
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light Red:");
      p.Fuel.Level := 10;
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light Flashing:");
      p.Fuel.Level := 5;
      FlightStatus(p);
      p.Fuel.Level := 50;
      Put_Line("");

      --Altitude checks
      Put_Line("-----------------Checking Altitude Light-----------------");
      Put_Line("WARNING: Readings will change during test");

      Put_Line("Light off:");
      FlightStatus(p);
      Put_Line("");

      --changing settings
      p.Flight := normal;
      p.CockpitDoor.Status := closed;
      p.CockpitDoor.Lock := locked;
      p.ExternalDoor.Status := closed;
      p.ExternalDoor.Lock := locked;
      p.Fuel.Level := 100;
      p.AirSpeed.Speed := 935;
      p.LandingGear.Position := up;
      p.Engine.Status := on;

      Put_Line("Light Amber:");
      p.Altitude.Altitude := 30000;
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light Red:");
      p.Altitude.Altitude := 25000;
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light Flashing:");
      p.Altitude.Altitude := 0;
      FlightStatus(p);
      Put_Line("");

      --returning settings to default
      p.Flight := stationary;
      p.CockpitDoor.Status := open;
      p.CockpitDoor.Lock := unlocked;
      p.ExternalDoor.Status := open;
      p.ExternalDoor.Lock := unlocked;
      p.Fuel.Level := 50;
      p.Altitude.Altitude := 0;
      p.AirSpeed.Speed := 0;
      p.LandingGear.Position := down;
      p.Engine.Status := off;


      --Altitude checks
      Put_Line("-----------------Checking Air Speed Light-----------------");
      Put_Line("WARNING: Readings will change during test");

      Put_Line("Light off:");
      FlightStatus(p);
      Put_Line("");

     --changing settings
      p.Flight := normal;
      p.CockpitDoor.Status := closed;
      p.CockpitDoor.Lock := locked;
      p.ExternalDoor.Status := closed;
      p.ExternalDoor.Lock := locked;
      p.Fuel.Level := 100;
      p.Altitude.Altitude := 35000;
      p.LandingGear.Position := up;
      p.Engine.Status := on;

      Put_Line("Light Amber:");
      p.AirSpeed.Speed := 920;
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light Red:");
      p.AirSpeed.Speed := 910;
      FlightStatus(p);
      Put_Line("");

      Put_Line("Light Flashing:");
      p.AirSpeed.Speed := 0;
      FlightStatus(p);
      Put_Line("");

      --return to default
      p.Flight := stationary;
      p.CockpitDoor.Status := open;
      p.CockpitDoor.Lock := unlocked;
      p.ExternalDoor.Status := open;
      p.ExternalDoor.Lock := unlocked;
      p.Fuel.Level := 50;
      p.Altitude.Altitude := 0;
      p.AirSpeed.Speed := 0;
      p.LandingGear.Position := down;
      p.Engine.Status := off;

      --landing gear
      Put_Line("-----------------Checking Landing Gear Light-----------------");
      Put_Line("WARNING: Readings will change during test");

      Put_Line("Light off:");
      FlightStatus(p);
      Put_Line("");

      --changing settings
      p.Flight := takeOff;
      p.CockpitDoor.Status := closed;
      p.CockpitDoor.Lock := locked;
      p.ExternalDoor.Status := closed;
      p.ExternalDoor.Lock := locked;
      p.Fuel.Level := 100;
      p.Altitude.Altitude := 11000;
      p.LandingGear.Position := up;
      p.Engine.Status := on;


      Put_Line("Light Amber:");
      FlightStatus(p);
      Put_Line("");

      p.Altitude.Altitude := 100;
      Put_Line("Light Flashing:");
      FlightStatus(p);
      Put_Line("");

      --return to default
      p.Flight := stationary;
      p.CockpitDoor.Status := open;
      p.CockpitDoor.Lock := unlocked;
      p.ExternalDoor.Status := open;
      p.ExternalDoor.Lock := unlocked;
      p.Fuel.Level := 50;
      p.Altitude.Altitude := 0;
      p.AirSpeed.Speed := 0;
      p.LandingGear.Position := down;
      p.Engine.Status := off;


      --engine light
      Put_Line("-----------------Checking Engine Light-----------------");
      Put_Line("WARNING: Readings will change during test");

      Put_Line("Light off:");
      FlightStatus(p);
      Put_Line("");

      --change settings
      p.Flight := normal;
      p.CockpitDoor.Status := closed;
      p.CockpitDoor.Lock := locked;
      p.ExternalDoor.Status := closed;
      p.ExternalDoor.Lock := locked;
      p.Fuel.Level := 100;
      p.Altitude.Altitude := 35000;
      p.AirSpeed.Speed := 935;
      p.LandingGear.Position := up;
      p.Engine.Status := off;

      Put_Line("Light Flashing:");
      FlightStatus(p);
      Put_Line("");

      --return to default
      p.Flight := stationary;
      p.CockpitDoor.Status := open;
      p.CockpitDoor.Lock := unlocked;
      p.ExternalDoor.Status := open;
      p.ExternalDoor.Lock := unlocked;
      p.Fuel.Level := 50;
      p.Altitude.Altitude := 0;
      p.AirSpeed.Speed := 0;
      p.LandingGear.Position := down;
      p.Engine.Status := off;
   end SystemCheck;


   procedure FlightSim ( p : in out PlaneRec) is
   begin


      Put_Line("-----------------Starting Flight Simulation-----------------");

      --set amount of fuel needed
      p.MinimumFuel := 75;
      Put_Line("Setting minimum amount of fuel needed to: " & P.MinimumFuel'Image & "%");

      Put_Line("Fuelling plane to 100%");
      SetFuelLevel(p.Fuel.Level, 100, p.MinimumFuel);

      --stationary mode
      Put_Line("Plane set to stationary mode, doors are unlocked and open, passengers can enter");

      Put_Line("Boarding has finished, doors will be closed and locked");
      CloseDoor(p.CockpitDoor.Status, p.Flight);
      CloseDoor(p.ExternalDoor.Status, p.Flight);
      LockDoor(p.CockpitDoor.Lock, p.Flight);
      LockDoor(p.ExternalDoor.Lock, p.Flight);

      Put_Line("-----------------FlightStatus as of finishing stationary activities-----------------");
      FlightStatus(p);
      Put_Line("");

      --tow mode
      Put_Line("Set plane to tow mode and tow plane to beginning of runway");
      EngineOff(p.Engine.Status, p.Flight);
      SetTowMode(p.Flight, p.CockpitDoor, p.ExternalDoor, p.Engine);


      Put_Line("-----------------FlightStatus as of being towed to beginning of runway-----------------");
      FlightStatus(p);
      Put_Line("");

      --take off
      Put_Line("Prepare for take off");
      --set takeOff
      p.Altitude.Altitude := 0;
      SetTakeOff(p.Flight, p.CockpitDoor, p.ExternalDoor, p.Fuel.Level, p.MinimumFuel, p.Altitude.Altitude, p.LandingGear.Position);

      --turn engine on
      EngineOn(p.Engine.Status, p.Flight);

      Put_Line("-----------------FlightStatus after take off checks have been compleated-----------------");
      FlightStatus(p);
      Put_Line("");


      Put_Line("Take off and climb to 35000 ft");
      --set air speed
      p.AirSpeed.Speed := 935;
      p.Altitude.Altitude := 35000;
      p.Fuel.Level := 90;
      p.LandingGear.Position := up;

      --set normal flight
      Put_Line("Setting Plane to normal flight mode");
      SetNormal(p.Flight, p.AirSpeed.Speed, p.Altitude.Altitude);

      Put_Line("-----------------FlightStatus when starting normal flight-----------------");
      FlightStatus(p);
      Put_Line("");

      --maintain normal flight
      Put_Line("Using computer to maintain normal flight in between parameters");
      Put_Line("Decreasing speed and altitude to show the computer correcting for altitude/speed loss");
      p.AirSpeed.Speed := 920;
      p.Altitude.Altitude := 30000;
      Put_Line("Air Speed: " & p.AirSpeed.Speed'Image & "km/h, Altitude: "& p.Altitude.Altitude'Image &"ft");

      MaintainNormalFlight(p.Flight, p.AirSpeed.Speed, p.Altitude.Altitude);
      p.Fuel.Level := 70;
      Put_Line("Decrease fuel to " & p.Fuel.Level'Image &"%");

      Put_Line("-----------------FlightStatus after returning to normal flight-----------------");
      FlightStatus(p);
      Put_Line("");

      p.Fuel.Level := 50;
      Put_Line("Decrease fuel to " & p.Fuel.Level'Image &"%");


      --decent
      Put_Line("Begin Descent to 10000ft");
      p.AirSpeed.Speed := 935;
      p.Altitude.Altitude := 10000;

      Put_Line("-----------------FlightStatus after beginning descent-----------------");
      FlightStatus(p);
      Put_Line("");

      --prepare for landing
      Put_Line("Prepare for landing");
      p.AirSpeed.Speed := 935;
      p.Altitude.Altitude := 10000;

      SetLanding(p.Flight, p.Altitude.Altitude, p.LandingGear.Position);
      Put_Line("-----------------FlightStatus after landing preparation-----------------");
      FlightStatus(p);
      Put_Line("");

      Put_Line("Touch Down");
      p.AirSpeed.Speed := 0;
      p.Altitude.Altitude := 0;
      p.Fuel.Level := 30;
      Put_Line("Decrease Air Speed and Altitude");

      Put_Line("-----------------FlightStatus after landing-----------------");
      FlightStatus(p);
      Put_Line("");

      --tow mode
      Put_Line("Set plane to tow mode and tow plane to end of runway");
      EngineOff(p.Engine.Status, p.Flight);
      SetTowMode(p.Flight, p.CockpitDoor, p.ExternalDoor, p.Engine);

      Put_Line("-----------------FlightStatus as of being towed to end of runway-----------------");
      FlightStatus(p);
      Put_Line("");

      Put_Line("Unlock Doors and let passengers disembark");
      Put_Line("Set Plane to stationary");
      SetStationary(p.Flight, p.Altitude.Altitude, p.AirSpeed.Speed);
      Put_Line("Unlock and open doors");
      OpenDoor(p.CockpitDoor.Status, p.Flight);
      OpenDoor(p.ExternalDoor.Status, p.Flight);
      UnlockDoor(p.CockpitDoor.Lock, p.Flight);
      UnlockDoor(p.ExternalDoor.Lock, p.Flight);

      Put_Line("-----------------Flight Simulation finished variables will be returned to default-----------------");
      --return to default
      p.Flight := stationary;
      p.Fuel.Level := 50;
      p.Altitude.Altitude := 0;
      p.AirSpeed.Speed := 0;
      p.LandingGear.Position := down;
      p.Engine.Status := off;

   end FlightSim;


end Aeroplane;
