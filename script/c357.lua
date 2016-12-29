--created by NovaTsukimori
--coded by Lyris
--インピュア召喚
function c357.initial_effect(c)
	if not c357.global_check then
		c357.global_check=true
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c357.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c357.filter(c)
	return c.impure
end
function c357.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c357.filter,0,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:GetFlagEffect(357)==0 then
			tc:EnableReviveLimit()
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetCode(EFFECT_SPSUMMON_CONDITION)
			if not tc.impure_nomi then
				e0:SetRange(LOCATION_EXTRA)
			end
			e0:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			e0:SetValue(function(e,se,sp,st) return bit.band(st,0x400)==0x400 end)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetDescription(aux.Stringid(357,0))
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(0x400)
			e1:SetCondition(c357.sumcon)
			e1:SetOperation(c357.sumop)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			if not tc.impure_xyz then
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
			end
			tc:RegisterFlagEffect(357,0,0,1)
		end
		tc=g:GetNext()
	end
end
function c357.matfilter(c,ipr)
	return ipr.material and ipr.material(c) and c:IsCanTurnSet()
end
function c357.sumcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c357.matfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c357.sumop(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(357,1))
	local mg=Duel.SelectMatchingCard(tp,c357.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.ChangePosition(mg,POS_FACEDOWN_ATTACK)
	Duel.Overlay(c,mg)
	local tc=mg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=mg:GetNext()
	end
end
