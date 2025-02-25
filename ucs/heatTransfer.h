#ifndef HEATTRANSFER_H__
#define HEATTRANSFER_H__

#include "general.h"
#include "eqnset.h"
#include "dataInfo.h"

template <class Type>
class HeatTransferEqnSet : public EqnSet<Type>
{
public:
  HeatTransferEqnSet(SolutionSpace<Type>* space, Param<Type>* p);
  ~HeatTransferEqnSet();

  void InitEqnSet();
  void RoeFlux(Type* QL , Type* QR, Type* avec, Type at, Type gamma, Type* flux, Type beta);
  void UpdateQinf();
  void ApplyDQ(Type* dQ, Type* Q, Type* xyz);
  void ViscousFlux(Type* Q, Type* grad, Type* avec, Type mut, Type* flux);
  void ViscousJacobian(Type* QL, Type* QR, Type* dx, Type s2,
		       Type* avec, Type mut, Type* aL, Type* aR);
  void ComputeAuxiliaryVariables(Type* Q);
  Int GetGradientsLocation(std::vector<Int>& gradientLoc);
  Int BadExtrapolation(Type* Q){return false;};
  void ExtrapolateVariables(Type* Qho, const Type* Q, const Type* dQedge,
			    const Type* gradQ, const Type* dx, const Type* limiter);
  void SetInitialConditions();
  void Dimensionalize(Type* Q);
  Type MaxEigenvalue(Type* Q, Type* avec, Type vdotn, Type gamma, Type beta);
  void GetInviscidWallBoundaryVariables(Type* QL, Type* QR, Type* Qinf, Type* avec, Type vdotn, Type beta);
  void GetIsothermalBoundaryVariables(Type* QL, Type* QR, Type Twall);
  void GetHeatFluxBoundaryVariables(Type* QL, Type* QR, Type* normalQ, Type* normaldx, Type flux);

  //returns the names of the residual terms (i.e. equations) for residual printing
  virtual std::vector<std::string> GetResidualNames(){
    std::vector<std::string> names;
    names.push_back("temperature");
    return names;
  }

 private:
  HeatTransferEqnSet();
  Type thermalDiffusivity; //alpha = k/rho.Cp
};

//include implementation
#include "heatTransfer.tcc"

#endif
