with Aeroplane; use Aeroplane;
with Ada.Text_IO; use Ada.Text_IO;


procedure Main is

      Str : String (1..2);
   Last : Natural;

   task EntryGuard;


   task body EntryGuard is
   begin
      loop
         Put_Line("Enter what you want to do:");
         Put_Line("1: Return Flight Status: ");
         Put_Line("2: Run System Checks: ");
         Put_Line("3: Launches Flight Simulation: ");
         Get_Line(Str,Last);
         case Str(1) is
         when '1' => FlightStatus(Plane);
         when '2' => SystemCheck(Plane);
         when '3' => FlightSim(Plane);
         when others => exit;
         end case;
      end loop;
   end EntryGuard;

begin
   null;
end Main;
