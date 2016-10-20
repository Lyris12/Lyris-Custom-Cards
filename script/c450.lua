--Spectrum Procedure
function c450.initial_effect(c)
	if not c450.global_check then
		c450.global_check=true
		--register
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c450.op)
		Duel.RegisterEffect(e1,0)
	end
end
function c450.regfilter(c)
	return c.spectrum
end
function c450.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c450.regfilter,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(450)==0 then
			tc:EnableReviveLimit()
			--spectrum summon
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetCondition(c450.spcon)
			e1:SetOperation(c450.spop)
			e1:SetValue(0x216)
			tc:RegisterEffect(e1)
			--A Spectrum Summon is a proper Special Summon
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetCondition(function(e) return bit.band(e:GetHandler():GetSummonType(),0x216)==0x216 end)
			e2:SetOperation(function(e) e:GetHandler():CompleteProcedure() end)
			tc:RegisterEffect(e2)
			--Prevents cards that affect Xyz Monsters from affecting Spectrum Monsters
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EFFECT_REMOVE_TYPE)
			e3:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetValue(1)
			tc:RegisterEffect(e4)
			--check the Spectrum Wheels
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_ADJUST)
			e5:SetRange(0xff)
			e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetOperation(c450.wheel)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EVENT_CHAIN_SOLVING)
			tc:RegisterEffect(e6)
			tc:RegisterFlagEffect(450,0,0,1)
		end
		tc=g:GetNext()
	end
end
function c450.spcon(e,c)
	if c==nil then return true end
	--c.material is the number to multiply by the monster's Wavelength to get the LP payment.
	if not c.material then return false end
	local tp=c:GetControler()
	--Pay LP equal to this Spectrum Monster's Wavelength x the number listed on this Spectrum Monster in order to Spectrum Summon.
	return Duel.CheckLPCost(tp,c.material*c:GetRank())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		--If your Spectrum Wheel is incomplete, then you cannot Spectrum Summon this monster.
		and Duel.GetFlagEffect(tp,10008000)~=0
end
function c450.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,c.material*c:GetRank())
end
function c450.wheel(e,tp,eg,ep,ev,re,r,rp)
	local red=Duel.GetFlagEffect(tp,10001000)
	local orange=Duel.GetFlagEffect(tp,10002000)
	local yellow=Duel.GetFlagEffect(tp,10003000)
	local green=Duel.GetFlagEffect(tp,10004000)
	local blue=Duel.GetFlagEffect(tp,10005000)
	local indigo=Duel.GetFlagEffect(tp,10006000)
	local purple=Duel.GetFlagEffect(tp,10007000)
	--You can view your progress on the Spectrum Wheel by hovering over a card on your field. The Number shown is the number of Spectrum Pieces on the Spectrum Wheel of that card's controller.
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local c=g:GetFirst()
	while c do
		c:SetHint(CHINT_NUMBER,red+orange+yellow+green+blue+indigo+purple)
		c=g:GetNext()
	end
end
