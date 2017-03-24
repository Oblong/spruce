
/* (c)  oblong industries */

namespace oblong {
namespace spruce {

class Spruce : public Truce
{
 public:
  int32 var1;
  float64 var2;

 OB_PROTECTED:
  int32 var3;
  float64 var4;

  class Bruce
  {
   OB_PROTECTED:
  int32 b1;
    int32 b2;

   public:
    Bruce () { b1 = b2 = 0; }
  };

 OB_PRIVATE:
     /**
   * this is var5. it holds data.
   */
    int32 var5;
  float64 var6;
  Bruce *bruce;

 public:
  /**
   * constructor
   */
  Spruce ()
  {
    var1 = var3 = var5 = 0;
    var2 = var4 = var6 = 0.0;
    bruce = new Bruce;
  }

  ~Spruce ()
  {
    delete bruce;
    var1 = 0;
  }

 OB_PROTECTED:
  void ProtectThisHouse ();
  void OnGuard ();

 OB_PRIVATE:
     void
    TheBathroomDoorReadsOccupied ();
  void DontOpenIt ();
};
}
}  // goodbye namespace oblong spruce
