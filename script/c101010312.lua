--created & coded by Lyris
--レインボー・アイズ・アマランス・パルス
function c101010312.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c101010312.cost)
	e1:SetTarget(c101010312.target)
	e1:SetOperation(c101010312.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101010312,ACTIVITY_SPSUMMON,c101010312.ctfilter)
end
function c101010312.ctfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or not c.spatial
end
function c101010312.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101010312.filter1(c,e,tp)
	return c:IsSetCard(0xb2d) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101010312.filter2,tp,LOCATION_MZONE,0,1,c,e,tp,c:GetLevel())
end
function c101010312.filter2(c,e,tp,lv)
	return c:IsSetCard(0xb2d) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101010312.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,c:GetLevel())
end 
function c101010312.cfilter(c,e,tp,lv1,lv2)
	return c.spatial and (c:IsSetCard(0xb2d) or (c:IsRace(RACE_DRAGON) and c:GetAttack()==2500 and c:GetDefense()==2000))
		and c:GetRank()==lv1+lv2 and c:IsCanBeSpecialSummoned(e,0x7150,tp,true,false)
end
function c101010312.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c101010312.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetCustomActivityCount(101010312,tp,ACTIVITY_SPSUMMON)==0
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabelObject(e)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c101010312.sumlimit)
	Duel.RegisterEffect(e0,tp)
	local g1=Duel.SelectMatchingCard(tp,c101010312.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c101010312.filter2,tp,LOCATION_MZONE,0,1,1,tc,e,tp,tc:GetLevel())
	g1:Merge(g2)
	e:SetLabel(g1:GetSum(Card.GetLevel))
	g1:KeepAlive()
	e:SetLabelObject(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010312.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se and c.spatial and c:IsLocation(LOCATION_EXTRA)
end
function c101010312.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010312.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv/2,lv/2)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(e:GetLabelObject())
		Duel.SpecialSummon(sc,0x7150,tp,tp,true,false,POS_FACEUP)
	end
end
