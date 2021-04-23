package Aeroplane with SPARK_mode is

  --Variables
  --door, status (open/closed), lock(locked, unlocked)
   type DStatus is (open, closed);
   type DLock is (unlocked, locked);

   type Door is record
      Status : Dstatus;
      Lock : DLock;
   end record;

  --flight status, (stationary, takeoff, normal, landing, tow)
   type FlightStage is (stationary, takeOff, normal, landing, tow);

   --fuel level (0..100), modelled as %
   type FuelLevel is range 0..100;

   --AirSpeed in km/h
   type AirSpeedRange is range 0..1000;

   --Altitude in ft
   type AltitudeRange is range 0..50000;

   --contains all variables needed for an aeroplane
   --variables are set to status needed for take off by default
  type Aeroplane is record
      CockpitDoor : Door := (Status => open, Lock => unlocked);
      ExternalDoor : Door := (Status => open, Lock => unlocked);
      Flight : FlightStage := stationary;
      Fuel : FuelLevel := 100;
      --is the minimum amount of fuel needed for takeoff
      MinimumFuel : FuelLevel := 50;
      Altitude : AltitudeRange := 0;
      AirSpeed : AirSpeedRange := 0;
   end record;


--Methods

--shut door
--takes door as input and shuts it
  procedure ShutDoor (d : in out Door) with
     Pre => d.Status = open,
     Post => d.Status = closed;

--open door
--takes door as input and opens it
  procedure OpenDoor (d : in out Door) with
     Pre => d.Status = closed,
     Post => d.Status = open;

--lock door
--takes door and locks it
   procedure LockDoor (d : in out Door) with
     Pre => d.Lock = unlocked,
     Post => d.Lock = locked;

--unlock door
--takes door and unlocks it
   procedure UnlockDoor (d : in out Door) with
    Pre => d.Lock = locked,
     Post => d.Lock = unlocked;


   --set fuel
   --allows fuel to be set to a specific level
   procedure SetFuel(f : out FuelLevel; i : in FuelLevel) with
     Pre => i <= FuelLevel'Last,
   Post => f <=FuelLevel'Last;

 --decrease fuel to level


--take off
--checks all doors are closed and locked
--takes amount of fuel needed and checks that amount is onboard
--sets flight status to takeoff
   procedure TakeOff (p : in out Aeroplane) with
     Pre => p.CockpitDoor.Status = closed and p.CockpitDoor.Lock = locked
     and p.ExternalDoor.Status = closed and p.ExternalDoor.Lock = locked
     and p.Fuel >= p.MinimumFuel,
     Post => p.Flight = takeOff;


   --maintain normal flight
   --keeps the plane within altitude and airspeed requirements
   -- values for post conditions were taken from googling average/max cruising speed and altitude for boing 737
   -- pre, within range
   -- post, altitude should be = 35000, speed should be = 933
   procedure MaintainNormalFlight (p : in out Aeroplane) with
     Post => p.Altitude = 35000 and p.AirSpeed = 933;


   --Flight status
   -- returns the status of the plane and warns if fuel is low
   procedure FlightStatus (p : in  Aeroplane);




end Aeroplane;
