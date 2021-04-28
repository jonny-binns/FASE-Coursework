package Aeroplane with SPARK_mode is

   --Variables
   type WarningLight is (off, AMBER, RED, FLASHING);

  --door, status (open/closed), lock(locked, unlocked)
   type DStatus is (open, closed);
   type DLock is (unlocked, locked);

   type Door is record
      Status : Dstatus;
      Lock : DLock;
      Light : WarningLight;
   end record;

  --flight status, (stationary, takeoff, normal, landing, tow, manual)
   type FlightStage is (stationary, takeOff, normal, landing, tow, manual);

   --fuel level (0..100), modelled as %
   type FuelLevelMeasure is range 0..100;

   type FuelLevel is record
      Level : FuelLevelMeasure;
      Light : WarningLight;
   end record;

   --AirSpeed in km/h
   type AirSpeedRange is range 0..1000;

      type ASpeed is record
         Speed : AirSpeedRange;
         Light : WarningLight;
      end record;


   --Altitude in ft
      type AltitudeRange is range 0..50000;

      type Alt is record
         Altitude : AltitudeRange;
         Light : WarningLight;
      end record;


   --Landing gear
   type LandingGearPos is (down, up);

   type LGear is record
      Position : LandingGearPos;
      Light : WarningLight;
   end record;

   --engines
      type EngineStatus is (on, off);

      type EStatus is record
         Status : EngineStatus;
         Light : WarningLight;
      end record;


   --contains all variables needed for an aeroplane, and sets defaults
   type PlaneRec is record
      CockpitDoor : Door := (Status => open, Lock => unlocked, Light => off);
      ExternalDoor : Door := (Status => open, Lock => unlocked, Light => off);
      Flight : FlightStage := stationary;
      Fuel : FuelLevel := (Level => 50, Light => off);
      --is the minimum amount of fuel needed for takeoff
      MinimumFuel : FuelLevelMeasure := 50;
      Altitude : Alt := (Altitude => 0, Light => off);
      AirSpeed : ASpeed := (Speed => 0, Light => off);
      LandingGear : LGear := (Position => down, Light => off);
      Engine : EStatus := (Status => off, Light => off);
   end record;

   Plane : PlaneRec;

   --Methods

   --set fuel level
   procedure SetFuelLevel (f : out FuelLevelMeasure; flevel : in FuelLevelMeasure; fmin : in FuelLevelMeasure) with
     Pre => flevel >= fmin,
     Post => f >= fmin and f = flevel;

   --close door
   procedure CloseDoor (d : out DStatus; f : in FlightStage) with
     Pre => f = stationary or f = manual,
     Post => d = closed;

   --open door
   procedure OpenDoor (d : out DStatus; f : in FlightStage) with
     Pre => f = stationary or f = manual,
     Post => d = open;

   --lock door
   procedure LockDoor (d : out DLock; f : in FlightStage) with
     Pre => f = stationary or f = manual,
     Post => d = locked;

   --unlock door
   procedure UnlockDoor (d : out DLock; f : in FlightStage) with
     Pre => f = stationary or f = manual,
     Post => d = unlocked;

   --turn off engine
   procedure EngineOff (e: out EngineStatus; f : in FlightStage) with
     Pre => f = stationary or f = landing or f = tow or f = manual,
     Post => e = off;

   --turn on engine
   procedure EngineOn (e: out EngineStatus; f : in FlightStage) with
     Pre => f = takeOff or f = manual,
     Post => e = on;


   --stationary
   procedure SetStationary (fmode: out FlightStage; al : in AltitudeRange; as : in AirSpeedRange) with
     Pre => al = 0 and as = 0,
     Post => fmode = stationary;

   --tow mode
   --sets the plane into tow mode
   procedure SetTowMode (fmode: out FlightStage; d1 : in Door; d2 : in Door; e : in EStatus) with
     Pre => d1.Status = closed and d1.Lock = locked
     and d2.Status = closed and d2.Lock = locked
     and e.Status = off,
     Post => fmode = tow;


    --take off
    --doors shut/locked
    --fuel needs to be more than minimum
    --if below 10000 landing gear down
   procedure SetTakeOff (fmode: out FlightStage; d1 : in Door; d2 : in Door; f : in FuelLevelMeasure; fmin : in FuelLevelMeasure; a : in AltitudeRange; lg : in out LandingGearPos) with
     Pre => d1.Status = closed and d1.Lock = locked
     and d2.Status = closed and d2.Lock = locked
     and f >= fmin,
     Post => fmode = takeOff;


      --set to normal flight
      --air speed/altitude are within range
      --landing gear up
   procedure SetNormal (fmode : out FlightStage; as : in AirSpeedRange; al : in AltitudeRange) with
     Pre => as = 935 and al = 35000,
   Post => fmode = normal;
--and al >= 30000 and al <= 40000

   --maintain normal flight
   --keeps airspeed/altitude within rabge
   --only be set when plane is in normal mode
   --reduce fuel
   procedure MaintainNormalFlight (fmode : in FlightStage; as : in out AirSpeedRange; al : in out AltitudeRange) with
     Pre => fmode = normal,
       Post => as = 935 and al = 35000;

   --landing
   --altitude below 10000
   --set landing gear below 10000
   procedure SetLanding (fmode : out FlightStage; al : in AltitudeRange; lg : in out LandingGearPos) with
     Pre => al <= 10000,
     Post => fmode = landing;





   --Flight status
   -- returns the status of the plane and controls warning lights
   procedure FlightStatus (p : in out PlaneRec) with
     Post => p.CockpitDoor.Status = p.CockpitDoor.Status'Old and p.CockpitDoor.Lock = p.CockpitDoor.Lock'Old
     and p.ExternalDoor.Status = p.ExternalDoor.Status'Old and p.ExternalDoor.Lock = p.ExternalDoor.Lock'Old
     and p.Flight = p.Flight'Old
     and p.MinimumFuel = p.MinimumFuel'Old
     and p.Fuel.Level = p.Fuel.Level'Old
     and p.Altitude.Altitude = p.Altitude.Altitude'Old
     and p.AirSpeed.Speed = p.AirSpeed.Speed'Old
     and p.LandingGear.Position = p.LandingGear.Position'Old
     and p.Engine.Status = p.Engine.Status'Old;



   --system checker
   --checks the integrity of the safety systems by looping through all possibilities
   --only allow when stationary
   procedure SystemCheck (p : in out PlaneRec) with
     Pre => p.Flight = stationary;

   --flight simulation
   --simulates a flight to show how individual methods work
   --only allow when stationary
   --returns everything to defaults at the end
   procedure FlightSim (p : in out PlaneRec) with
   Pre => p.Flight = stationary;
end Aeroplane;
