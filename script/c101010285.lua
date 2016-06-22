--ＳＳ－Ｓ・Ｖｉｎｅ スターモス
local id,ref=GIR()
function ref.start(c)
--synchro
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_ADD_TYPE)
	ae1:SetValue(TYPE_SYNCHRO)
	ae1:SetCondition(ref.atcon)
	c:RegisterEffect(ae1)
	--boost
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(LOCATION_MZONE,0)
	ae2:SetTarget(ref.syntg)
	ae2:SetValue(1000)
	c:RegisterEffect(ae2)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.spatial=true
--Spatial Formula filter(s)
ref.material1=function(mc) return c:IsNotTuner() and c:IsAbleToRemoveAsCost() end
ref.material2=function(mc) return c:IsAbleToRemoveAsCost() end -- Invert this block of code on Division Spatial Monsters (begin)
ref.mult_spatial=true
--ref.divs_spatial=true --Division Procedure /
--ref.stat=function(mc) return mc:GetAttack() or mc:GetDefence() or mc:GetAttack()-mc:GetDefence() end
--ref.indicator=function(mc) return mc:GetLevel() or mc:GetRank() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function ref.atcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function ref.syntg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c~=e:GetHandler()
end
