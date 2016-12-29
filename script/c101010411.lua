--created & coded by Lyris
--FFフェニックス
function c101010411.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c101010411.regop)
	c:RegisterEffect(e2)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101010411.ffilter1,c101010411.ffilter2,true)
end
function c101010411.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_WIND) or (c:IsHasEffect(101010012) and not c:IsLocation(LOCATION_DECK))
end
function c101010411.ffilter2(c)
	return c:IsRace(RACE_DRAGON+RACE_WINDBEAST) or (c:IsHasEffect(101010085) and not c:IsLocation(LOCATION_DECK))
end
function c101010411.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(101010055) then
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetCondition(c101010411.con)
		e2:SetTarget(c101010411.tg)
		e2:SetOperation(c101010411.op)
		e2:SetReset(RESET_EVENT+EVENT_TO_DECK)
		c:RegisterEffect(e2)
	end
end
function c101010411.filter(c)
	return c:IsSetCard(0xa88) and c:IsFaceup()
end
function c101010411.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101010411.filter,tp,LOCATION_MZONE,0,2,nil)
end
function c101010411.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010411.thfilter(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsAbleToHand() and c:IsCode(101010552)
end
function c101010411.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c101010411.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010565,0)) then
			local tc=g:Select(tp,1,1,nil)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e3)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101010411.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c101010411.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa88)
end
function c101010411.fus(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re~=e end
	local c=e:GetHandler()
	c101010411.rndop(e,tp,c)
	e:Reset()
	return true
end
